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
variable "db_pass" {
  description = "password for database #dev"
  type        = string
  sensitive   = true
}
output "db_host" {
  value = module.web_app.db_host
}

output "bastion_host" {
  value = module.web_app.bastion_host
}

module "web_app" {
  source = "../../modules/web-app"

  # Input Variables
  app_name = "cardeal-api"

  prefix = "${local.environment_name}-cardeal"

  # bucket_prefix    = "cardeal-tf-state-${local.environment_name}"
  # domain           = "devopsdeployed.com"
  environment_name = local.environment_name
  instance_type    = "t2.micro"
  path_public_key  = "~/.ssh/aws_001.pub"
  # create_dns_zone  = terraform.workspace == "production" ? true : false
  storage_type   = "gp2"
  engine         = "postgres"
  engine_version = "12"
  instance_class = "db.t2.micro"
  db_name        = "cardealapidbdev"
  db_user        = "postgres"
  db_pass        = var.db_pass
}

