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

# TODO: Enable ArgoCD commands after the GRPC server is properly set up
# if argocd app get fileops-dev >/dev/null 2>&1; then
# 	echo "Destorying the app workloads..."
# 	argocd app delete fileops-dev --cascade
# 	echo "Destorying the app workloads is complete"
# fi
# if argocd app get argo-infra >/dev/null 2>&1; then
# 	echo "Destorying the argocd infra workloads..."
# 	argocd app delete argo-infra --cascade
# 	echo "Destorying the argocd infra is complete."
# fi

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
