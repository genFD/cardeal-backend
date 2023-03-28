# ###############################################################
#                      # Load Balancer #                        #
#                --------------------------------               #
# Resources             Name           Number                   #
# ---------           | -------      | ------                   #
# Load Balancer       |  lb          |   1                      #
# Target group (TG)   |  instances   |   1                      #
# Listener            |  http        |   1                      #
#    -                |  https       |   1                      #
# TG Attachment       |   -          |   1                      #
# Listener rule       |   -          |   1                      #
# ###############################################################

resource "aws_lb" "api" {
  name               = "${var.prefix}-main"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  security_groups = [aws_security_group.lb.id]

  tags = {
    Name = "${var.prefix}-main-load-balancer"
  }

}

# resource "aws_lb_target_group" "api" {
#   name        = "${var.prefix}-api"
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"
#   port        = 8000

#   #TODO: TEST BEFORE DEPLOY IN PROD
#     # health_check {
#     #   path                = "/"
#     #   protocol            = "HTTP"
#     #   matcher             = "200"
#     #   interval            = 15
#     #   timeout             = 3
#     #   healthy_threshold   = 2
#     #   unhealthy_threshold = 2
#     # }

#   health_check {
#     path = "/"
#   }
# }


# resource "aws_lb_listener" "api" {
#   load_balancer_arn = aws_lb.api.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "api_https" {
#   load_balancer_arn = aws_lb.api.arn
#   port              = 443
#   protocol          = "HTTPS"

#   certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.api.arn
#   }
# }


