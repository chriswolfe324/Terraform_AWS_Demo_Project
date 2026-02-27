terraform {
  required_version = ">=1.14.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.33.0" # correct version constraint ? 
    }
  }
}

provider "aws" {
  region = var.project_region
  default_tags {
    tags = {
      Project = var.project_tag_name
    }
  }
}