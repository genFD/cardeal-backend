terraform {
  backend "s3" {
    bucket         = "01.api-tf-state"
    key            = "api.tfstate"
    region         = "us-east-1"
    dynamodb_table = "api-tf-state-locking"
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


module "web_app" {
  source = "../../modules/web-app"

  # Input Variables
  app_name = "backend"

  prefix = "${local.environment_name}-backend"
  domain           = "fsgig.com"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
  path_public_key  = "./pub_key/aws_001.pub"
  # create_dns_zone  = terraform.workspace == "production" ? true : false
  storage_type   = "gp2"
  engine         = "postgres"
  engine_version = "12"
  instance_class = "db.t2.micro"
  db_name        = "dbdev"
  db_user        = "postgres"
  db_pass        = var.db_pass
}


locals {
  environment_name = terraform.workspace
}


