terraform {
  required_version = ">= 0.14.0"

  backend "local" {
    path = ".tfstate/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
  }
}
