terraform {
  required_version = "1.15.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }
  }

  cloud {
    organization = "janice-zhong"

    workspaces {
      name = "janice-zhong-fileops-data"
    }
  }
}

provider "aws" {
  region = var.region
}
