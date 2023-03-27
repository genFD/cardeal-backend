###################################################################
#                       # Storage #     #
#                ---------------------------                      #
# Resources             Name                 Number               #
# ---------           | -------            | ------               #
# S3 Bucket           |  app_public_files  |    1   
# S3 Bucket ACL       |  s3_acl            |    1                 #
###################################################################

# resource "aws_s3_bucket" "app_public_files" {
#   bucket_prefix = "${var.prefix}-files"
#   force_destroy = true
#   tags = {
#     Name = "${var.prefix}-public-bucket"
#   }
# }

# resource "aws_s3_bucket_acl" "s3_acl" {
#   bucket = aws_s3_bucket.app_public_files.id
#   acl    = "public-read"
# }