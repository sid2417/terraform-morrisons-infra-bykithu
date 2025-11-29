terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.16.0"
    }
  }

  backend "s3" {
    bucket = "dev-morrisons-infra"
    key    = "dev-morrisons-infra-web-alb-remotestate"
    region = "us-east-1"
    dynamodb_table = "dev-morrisons-infra-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}