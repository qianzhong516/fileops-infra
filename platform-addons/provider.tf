terraform {
  required_version = "1.15.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.1.0"
    }
  }

  cloud {
    organization = "janice-zhong"

    workspaces {
      name = "janice-zhong-fileops-platform-addons"
    }
  }
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  token                  = local.cluster_token
}

provider "helm" {
  kubernetes = {
    host                   = local.cluster_endpoint
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token                  = local.cluster_token
  }
}
