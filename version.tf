terraform {
  required_version = "~> 1.5.5"

  required_providers {
    aws = {
      version = "~> 5.23.1"
      source  = "hashicorp/aws"
    }
  }
}