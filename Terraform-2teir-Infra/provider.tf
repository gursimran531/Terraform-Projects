terraform {
  cloud {
    organization = "Singhops"

    workspaces {
      project = "Terraform Project 2"
      name    = "Terraform-VPC-BastionApp"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11.0"
    }
  }


  required_version = ">= 1.13.0"
}

provider "aws" {
  region = var.awsregion
}

