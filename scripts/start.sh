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
