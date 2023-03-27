# resource "aws_ecs_cluster" "main" {
#   name = "${var.prefix}-cluster"

#   tags = {
#     Name = "${var.prefix}-cluster"
#   }
# }


# data "template_file" "api_container_definition" {
#   template = file("${path.module}/templates/ecs/container-definition.json.tpl")

#   vars = {
#     app_image        = var.ecr_image_api
#     db_host          = aws_db_instance.main.address
#     db_name          = aws_db_instance.main.db_name
#     db_user          = aws_db_instance.main.username
#     db_pass          = aws_db_instance.main.password
#     log_group_name   = aws_cloudwatch_log_group.ecs_task_logs.name
#     log_group_region = data.aws_region.current.name
#     allowed_hosts    = aws_route53_record.app.fqdn
#     #TODO: REPLACE WITH ACTUAL HOST ^^
#     # allowed_hosts = aws_lb.api.dns_name

#     s3_storage_bucket_name   = aws_s3_bucket.app_public_files.bucket
#     s3_storage_bucket_region = data.aws_region.current.name

#   }
# }

# resource "aws_ecs_task_definition" "api" {
#   family                   = "${var.prefix}-api"
#   container_definitions    = data.template_file.api_container_definition.rendered
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn       = aws_iam_role.task_execution_role.arn
#   task_role_arn            = aws_iam_role.app_iam_role.arn
#   # depends_on = [aws_lb_listener.api_https]

#   tags = {
#     Name = "${var.prefix}-api"
#   }
# }


# resource "aws_ecs_service" "api" {
#   name             = "${var.prefix}-api"
#   cluster          = aws_ecs_cluster.main.name
#   task_definition  = aws_ecs_task_definition.api.family
#   desired_count    = 1
#   launch_type      = "FARGATE"
#   platform_version = "1.4.0"

#   network_configuration {
#     subnets = [
#       aws_subnet.private_a.id,
#       aws_subnet.private_b.id,
#     ]
#     security_groups = [aws_security_group.ecs_service.id]
#   }

#   #TODO:potential bug due to absence of proxy in cardeal-api
#   load_balancer {
#     target_group_arn = aws_lb_target_group.api.arn
#     container_name   = "api"
#     container_port   = 8000
#   }
#   depends_on = [
#     aws_lb_listener.api_https
#   ]

# }

# data "template_file" "ecs_s3_write_policy" {
#   template = file("${path.module}/templates/ecs/s3-write-policy.json.tpl")

#   vars = {
#     bucket_arn = aws_s3_bucket.app_public_files.arn
#   }
# }



# resource "aws_cloudwatch_log_group" "ecs_task_logs" {
#   name = "${var.prefix}-api"

#   tags = {
#     Name = "${var.prefix}-api-log-group"
#   }

# }