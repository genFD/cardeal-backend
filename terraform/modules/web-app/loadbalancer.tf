# ###############################################################
#                      # Load Balancer #                        #
#                --------------------------------               #
# Resources             Name           Number                   #
# ---------           | -------      | ------                   #
# Listener            |  http        |   1                      #
# Target group (TG)   |  instances   |   1                      #
# TG Attachment       |   -          |   1                      #
# Listener rule       |   -          |   1                      #
# Security group      |  alb         |   1                      #
# Security group rule |  alb rule    |   1                      #
# Load Balancer       |  lb          |   1                      #
# ###############################################################

resource "aws_lb" "api" {
  name               = "${var.prefix}-main"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  security_groups = [aws_security_group.lb.id]

  tags ={
   Name = "${var.prefix}-main-load-balancer"
  }

}

resource "aws_lb_target_group" "api" {
  name        = "${var.prefix}-api"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  port        = 8000

  health_check {
    path = "/admin/login/"
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

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

  # certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.api.arn
#   }
# }






# ########
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.load_balancer.arn

#   port = 80

#   protocol = "HTTP"

#   # By default, return a simple 404 page
#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "404: page not found"
#       status_code  = 404
#     }
#   }
# }

# resource "aws_lb_target_group" "instances" {
#   name     = "${var.app_name}-${var.environment_name}-tg"
#   port     = 8080
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.default_vpc.id

#   health_check {
#     path                = "/"
#     protocol            = "HTTP"
#     matcher             = "200"
#     interval            = 15
#     timeout             = 3
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }

# resource "aws_lb_target_group_attachment" "instance_1" {
#   target_group_arn = aws_lb_target_group.instances.arn
#   target_id        = aws_instance.instance_1.id
#   port             = 8080
# }

# resource "aws_lb_target_group_attachment" "instance_2" {
#   target_group_arn = aws_lb_target_group.instances.arn
#   target_id        = aws_instance.instance_2.id
#   port             = 8080
# }

# resource "aws_lb_listener_rule" "instances" {
#   listener_arn = aws_lb_listener.http.arn
#   priority     = 100

#   condition {
#     path_pattern {
#       values = ["*"]
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.instances.arn
#   }
# }


# resource "aws_security_group" "alb" {
#   name = "${var.app_name}-${var.environment_name}-alb-security-group"
# }

# resource "aws_security_group_rule" "allow_alb_http_inbound" {
#   type              = "ingress"
#   security_group_id = aws_security_group.alb.id

#   from_port   = 80
#   to_port     = 80
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]

# }

# resource "aws_security_group_rule" "allow_alb_all_outbound" {
#   type              = "egress"
#   security_group_id = aws_security_group.alb.id

#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]

# }


# resource "aws_lb" "load_balancer" {
#   name               = "${var.app_name}-${var.environment_name}-web-app-lb"
#   load_balancer_type = "application"
#   subnets            = data.aws_subnet_ids.default_subnet.ids
#   security_groups    = [aws_security_group.alb.id]

# }
