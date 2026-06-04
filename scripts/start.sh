#!/bin/bash
set -e

# Disable AWS CLI Pager
export AWS_PAGER=""

# Check if required packages are installed
required_deps=("aws" "terraform")
for dep in "${required_deps[@]}"; do
	if ! command -v "$dep" >/dev/null 2>&1; then
		echo "$dep is not installed"
		exit 1
	fi
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

eks_encrypt_key_arn="arn:aws:kms:ap-southeast-2:665303624691:key/5a9bede7-34fc-474e-b361-1722901c9189"
sops_encrypt_key_arn="arn:aws:kms:ap-southeast-2:665303624691:key/ddb3f1ef-5194-4fa2-b4e1-e914831a249b"

# Enable KMS keys
keys=("$eks_encrypt_key_arn" "$sops_encrypt_key_arn")
for key in "${keys[@]}"; do
	key_state=$(aws kms describe-key --key-id "$key" --query 'KeyMetadata.KeyState' --output text)
	if [[ $key_state == "PendingDeletion" ]]; then
		aws kms cancel-key-deletion --key-id "$key"
	fi

	if [[ $key_state != "Enabled" ]]; then
		aws kms enable-key --key-id "$key"
	fi
done

# Deploy resources in stages
cd "$ROOT_DIR"/cluster
if ! terraform state show aws_kms_key.eks_encryption_key >/dev/null 2>&1; then
	echo "Importing EKS encryption key..."
	terraform import aws_kms_key.eks_encryption_key $eks_encrypt_key_arn
	echo "EKS encryption key has been imported."
fi
echo "Deploying cluster infra..."
terraform apply --auto-approve
echo "EKS cluster has been deployed successfully."
kubectl=$(terraform output -raw kubectl)

cd "$ROOT_DIR"/data
echo "Deploying data infra..."
terraform apply --auto-approve
echo "Data infra has been deployed successfully."
rds_secret_name=$(terraform output -raw rds_secret_name)
db_host=$(terraform output -raw db_host)
tls_cert_arn=$(terraform output -raw tls_cert_arn)

cd "$ROOT_DIR"/platform-addons
if ! terraform state show aws_kms_key.sops_key >/dev/null 2>&1; then
	echo "Importing SOPS encryption key..."
	terraform import aws_kms_key.sops_key $sops_encrypt_key_arn
	echo "SOPS encryption key has been imported."
fi
echo "Deploying platform addons..."
terraform apply --auto-approve
echo "Platform addons have been deployed successfully."

cd "$ROOT_DIR"/workloads
echo "Deploying workloads..."
terraform apply --auto-approve
echo "Workloads have been deployed successfully."

cat <<EOF
==========================================================================
Congratulations! Deployment is successful. Please perform the following steps next:
1) Update the secret object name for \`db-secrets\` in app manifests to $rds_secret_name
2) Update the DB_HOST in backend.yml to $db_host
3) Run \`$kubectl\` to connect to your cluster
4) Update TLS cert arn to \`$tls_cert_arn\` in your argocd, frontend ALB, backend ALB ingress files respectively.
5) Update the following DNS records in Route53:
	filesops.com A <fileops-alb-address-alias>
	api.filesops.com A <fileops-alb-address-alias>
	argocd.filesops.com A <fileops-internal-alb-address-alias>
	grafana.filesops.com A <fileops-internal-alb-address-alias>
6) Run \`k apply -f argo-ingress.yml\` to update the Argocd ALB.
==========================================================================
EOF
