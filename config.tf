## Specify AWS as provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  profile =                 var.profile
  shared_credentials_files  = ["${var.credential_path}"]
  region =                  var.aws_region
}


# Create a VPC
resource "aws_vpc" "static_website" {
  cidr_block = "10.0.0.0/16"
}