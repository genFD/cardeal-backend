##################################################################
#                     # Compute #                                #
#            --------------------------------                    #
# Resources             Name             Number                  #
# ---------           | -------        | ------                  #
# Aws instance        |  bastion       |   1                     #
#                     |                |                         #
##################################################################
# Data                  Name             Number                  #
# ---------           | -------        | ------                  #
# Aws ami             |  amazon_linux  |   1                     #
#                     |                |                         #
##################################################################

# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.0.*-kernel-6.1-x86_64"]
#   }

# }

# resource "aws_instance" "bastion" {
#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = var.instance_type
#   user_data     = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo amazon-linux-extras install -y docker
#               sudo systemctl enable docker.service
#               sudo systemctl start docker.service
#               sudo usermod -aG docker ec2-user
#               EOF
#   vpc_security_group_ids = [
#     aws_security_group.bastion_network_access.id
#   ]
#   subnet_id            = aws_subnet.public_a.id
#   key_name             = aws_key_pair.key_pair.key_name
#   iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
#   tags = {
#     Name = "${var.prefix}-bastion-server"
#   }
# }

