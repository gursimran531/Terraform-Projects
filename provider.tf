terraform {
  cloud {
    organization = "Singhops"

    workspaces {
      project = "Practice Project 1"
      name    = "practice-project-P1"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.10.0"
    }
  }


  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}