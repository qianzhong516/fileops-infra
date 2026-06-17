# FileOps Infrasturcture Terraform Setup

## Set up

To start deploying the app:

```bash
cd scripts/
./start.sh
```

## Destroy

```bash
cd scripts/
./destroy.sh
```

## Intro

The infrastructure setup is divided into a few parts:

1. The EKS cluster setup (`cluster/`)
2. Data resources (`data/`): RDS Database
3. Platform (`platform-addons/`): ArgoCD, Load Balancer Controller
4. Workloads (`workloads/`): ArgoCD apps

## GitOps Tools

`tflint` and `t validate` are added to precommit hooks.

## GitHub Workflows

- **Pull requests:** `terraform plan` runs and posts results as PR comments.
- **Push to `main`:** non-speculative plan + apply, gated by manual approval per stack (`cluster`, `data`, `platform-addons`, `workloads`).

## Terraform Docs

Each resource group has its Terraform doc embedded in the README.md.

## Remote State

The remote state is saved on HCP Terraform.
