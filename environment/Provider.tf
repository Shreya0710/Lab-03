# Configuration of the provider
terraform {
required_providers {
aws = {
source = "hashicorp/aws"
   }
  }
}

# Configuration of the AWS provider parameters
provider "aws" {
region = "us-east-1"
}