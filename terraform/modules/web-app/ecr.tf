###################################################################
#            # Container Repository # #                           #
#            --------------------------------                     #
# Resources             Name             Number                   #
# ---------           | -------        | ------                   #
# ECR Repository      |  main_repo     |   1                      #
#                     |                |                          #
###################################################################

resource "aws_ecr_repository" "main_repo" {
  name = "${var.prefix}-repo"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.prefix}-repo"
  }
}

resource "aws_ecr_repository" "second_repo" {
  name = "${var.prefix}-repo-test"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.prefix}-repo-test"
  }
}



