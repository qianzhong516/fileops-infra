# FileOps Infrasturcture Terraform Setup

## Intro

The infrastructure setup is divided into two parts:

1. The EKS cluster setup
2. The workload setup within the EKS cluster

In the EKS cluster setup, the focus is on setting up network, worker nodes, IGW, NATs, infrastructure components surrounding the cluster.

In the workload setup, the focus is on setting up the ArgoCD workloads because the FileOps project follows GitOps principals and a separate repo is going to be used for managing workload manifests.

## Git Workflows

- `terraform plan` runs when a PR is created/modified.
- `terraform apply` runs when a PR is merged/a push to the `main` branch

The workflows are run against the `eks/` or `helm/` based on where changes are from. Workflows can be run aginst both directories in one go but the workflow for `helm/` is always run after the workflow for `eks/` completes.

## Remote State

The remote state is saved on HCP Terraform.
