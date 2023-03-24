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
resource "aws_iam_policy" "task_execution_role_policy" {
  name        = "${var.prefix}-task-exec-role-policy"
  path        = "/"
  description = "Allow retrieving images and adding to logs"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.prefix}-task-exec-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
  EOF
  tags = {
    Name = "${var.prefix}-iam-role-task-exec"
  }
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}

resource "aws_iam_role" "app_iam_role" {
  name               = "${var.prefix}-api-task"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
  EOF

  tags = {
    Name = "${var.prefix}-api-task"
  }
}
################################
#S3

resource "aws_iam_policy" "ecs_s3_access" {
  name        = "${var.prefix}-AppS3AccessPolicy"
  path        = "/"
  description = "Allow access to the app S3 bucket"

  policy = data.template_file.ecs_s3_write_policy.rendered
}

resource "aws_iam_role_policy_attachment" "ecs_s3_access" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = aws_iam_policy.ecs_s3_access.arn
}
