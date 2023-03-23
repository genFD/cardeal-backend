###################################################################
# Description : 
# Allow Permission EC2 instance/AWS Container Registry
#            --------------------------------                     #
# Resources             Name                         Number       #
# ---------           | -------                    | ------       #
# IAM Role            |  bastion_role              |   1          #
# Policy Attachment   |  bastion_attach_policy     |   1          #
# Instance Profile    |  bastion_profile           |   1          #
###################################################################
# Description : 
# Allow Permission EC2 instance/AWS Container Registry
#            --------------------------------                     #
# Policy Attachment   |  bastion_attach_policy     |   1          #
# Instance Profile    |  bastion_profile           |   1          #
###################################################################

#EC2 Instance

resource "aws_iam_role" "bastion_role" {
  name               = "${var.prefix}-bastion-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
  EOF

  tags = {
    Name = "${var.prefix}-bastion-role"
  }
}


resource "aws_iam_role_policy_attachment" "bastion_attach_policy" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}

# #ECS
# resource "aws_iam_policy" "task_execution_role_policy" {
#   name        = "${local.prefix}-task-exec-role-policy"
#   path        = "/"
#   description = "Allow retrieving images and adding to logs"
#   policy      = file("./templates/ecs/task-exec-role.json")
# }

# resource "aws_iam_role" "task_execution_role" {
#   name               = "${local.prefix}-task-exec-role"
#   assume_role_policy = file("./templates/ecs/assume-role-policy.json")
#   tags               = "${local.prefix}-iam-role-task-exec"
# }

# resource "aws_iam_role_policy_attachment" "task_execution_role" {
#   role       = aws_iam_role.task_execution_role.name
#   policy_arn = aws_iam_policy.task_execution_role_policy.arn
# }

# resource "aws_iam_role" "app_iam_role" {
#   name               = "${local.prefix}-api-task"
#   assume_role_policy = file("./templates/ecs/assume-role-policy.json")

#   tags = "${local.prefix}-api-task"
# }

# resource "aws_cloudwatch_log_group" "ecs_task_logs" {
#   name = "${local.prefix}-api"

#   tags = "${local.prefix}-api-log-group"
# }
