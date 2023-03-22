resource "aws_ecr_repository" "main_repo" {
  name = "${var.prefix}-repo"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.prefix}-repo"
  }
}

