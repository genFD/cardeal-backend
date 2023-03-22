terraform {
  backend "s3" {
    bucket         = "cardeal-api-tf-state"
    key            = "01-cardeal.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cardeal-api-tf-state-locking"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  environment_name = terraform.workspace
}

module "web_app" {
  source = "../../modules/web-app"

  # Input Variables
  prefix = "${local.environment_name}-cardeal"
  # bucket_prefix    = "cardeal-tf-state-${local.environment_name}"
  # domain           = "devopsdeployed.com"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
  # path_public_key  = "$HOME/.ssh/aws_001.pub"
  # create_dns_zone  = terraform.workspace == "production" ? true : false
  # db_name          = "${local.environment_name}-cardeal-db"
  # db_user          = "postgres"
  # db_pass          = var.db_pass
}

