terraform {
    required_version = ">=1.14.4"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>6.33.0"    # correct version constraint ? 
        }
    }
}

provider "aws" {
    region = "us-east-2"
    default_tags {
        tags = {
            Project = "Terraform and AWS Demo"
        }
    }
}