###################################################################
#                 # Key Pair for SSH connection #                 #
#                ---------------------------                      #
# Resources             Name             Number                   #
# ---------           | -------        | ------                   #
# SSH KEY             |  key_pair      |   1                      #
###################################################################



resource "aws_key_pair" "key_pair" {
  key_name   = "aws_001"
  public_key = file(var.path_public_key)
}
