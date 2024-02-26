terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.7.0"
    }
  }

  backend "s3" {
    bucket = "tf-state-bucket-de-totes-project"
    key = "cicdexample/tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
    region = "eu-west-2"
}