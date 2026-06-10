#!/bin/bash
set -e

# Check if required packages are installed
required_deps=("argocd" "terraform")
for dep in "${required_deps[@]}"; do
	if ! command -v "$dep" >/dev/null 2>&1; then
		echo "$dep is not installed"
		exit 1
	fi
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Delete Argocd apps
# echo "Logging into Argocd Server..."
# password=$(argocd admin initial-password -n argocd | head -n 1)
# argocd login argocd.filesops.com --username "admin" --password "$password"
# echo "Login is complete."

# argo_apps=("karpenter-infra" "fileops-dev" "argocd-infra")
# for app in "${argo_apps[@]}"; do
# 	if argocd app get "$app" >/dev/null 2>&1; then
# 		echo "Destorying $app workloads..."
# 		argocd app set "$app" --source-position 1 --sync-policy none
# 		argocd app delete "$app" --cascade -y
# 		# TODO: Waiting for ALBs to be deleted
# 		echo "Destorying $app workloads is complete"
# 	fi
# done

# Delete Terraform workloads
cd "$ROOT_DIR"/workloads
echo "Destorying the workload resources..."
terraform destroy --auto-approve
echo "Destorying the workload resources is complete."

cd "$ROOT_DIR"/platform-addons
echo "Destorying the platform resources..."
terraform destroy --auto-approve
echo "Destorying the platform resources is complete."

cd "$ROOT_DIR"/data
echo "Destorying the data resources..."
terraform destroy --auto-approve
echo "Destorying the data resources is complete."

cd "$ROOT_DIR"/cluster
echo "Destorying the cluster resources..."
terraform destroy --auto-approve
echo "Destorying the cluster resources is complete."

cat <<EOF
==========================================================================
Congratulations! Deletion is successful. Please perform the following steps next:
1) Remove the prometheus alert manager volume from your AWS account
==========================================================================
EOF
