terraform {
  cloud {
    organization = "Singhops"

    workspaces {
      project = "Project3"
      name    = "dev"
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
