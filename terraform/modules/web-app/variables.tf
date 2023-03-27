###################################################################
#                 # General Variables #                           #
#                 --------------------                            #
# Variable            Default_Name                                #
# ---------        |  -------          |                          #
# Region           |  terraform_state  |                          #
# App Name         |  instances        |                          #
# Environment      |      -            |                          #
# Prefix           |      -            |                          #
###################################################################
#                   # EC2 Variables #                             
#                  -------------------                            #
# Public Key       |      -           |                           #
# Amazon Machine   |      -           |                           #
# Instance type    |      -           |                           #
###################################################################
#                    # S3 Variables #                             #
#                 ---------------------                           #
# Bucket Prefix    |      -            |                          #
###################################################################
#                  # Route 53 Variable #                          #
#                 ----------------------                          #
# Bucket Prefix   |       -            |                          #
###################################################################
#                  # RDS Variables #                              #
#                 --------------------                            #
# Database Name     |       -                                     #
# Database User     |       -                                     #
# Database Password |       -                                     #
###################################################################

variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the web application"
  type        = string
  default     = "web-app"
}

variable "environment_name" {
  description = "Deployment environment (dev/prod)"
  type        = string
  default     = "dev"
}

variable "prefix" {
  description = "resource prefix"
  type        = string
}

variable "path_public_key" {
  description = "Public key"
  type        = string
}


# EC2 Variables
# variable "ami" {
#   description = "Amazon machine image to use for ec2 instance"
#   type        = string
#   default     = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
# }

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

# S3 Variables

# variable "bucket_prefix" {
#   description = "prefix of s3 bucket for app data"
#   type        = string
# }

# RDS Variables


variable "storage_type" {
  description = "Type of storage"
  type        = string
}

variable "engine" {
  description = "Type of db engine (postgres|mysql|etc..)"
  type        = string
}

variable "engine_version" {
  description = "engine version"
  type        = string
}

variable "instance_class" {
  description = "instance class"
  type        = string
}

variable "db_name" {
  description = "Name of DB"
  type        = string
}

variable "db_user" {
  description = "Username for DB"
  type        = string
}

variable "db_pass" {
  description = "Password for DB"
  type        = string
  sensitive   = true
}

# ECR Variables

variable "ecr_image_api" {
  description = "ECR Image for API"
  default     = "302671405705.dkr.ecr.us-east-1.amazonaws.com/dev-cardeal-repo:latest"
}

### Route 53 Variables

# variable "create_dns_zone" {
#   description = "If true, create new route53 zone, if false read existing route53 zone"
#   type        = bool
#   default     = false
# }

# variable "domain" {
#   description = "Domain for website"
#   type        = string
# }

variable "dns_zone_name" {
  description = "Domain name"
  default     = "fsgig.com"
}

variable "subdomain" {
  description = "Subdomain per environment"
  type        = map(string)
  default = {
    production = "cardealapi"
    dev        = "cardealapi.dev"
  }

}