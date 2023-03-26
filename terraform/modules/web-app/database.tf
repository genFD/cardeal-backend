###################################################################
#            # Database/Private subnet # #                        #
#            --------------------------------                     #
# Resources             Name             Number                   #
# ---------           | -------        | ------                   #
# Database instance   |  main          |   1                      #
#                     |                |                          #
###################################################################

# resource "aws_db_instance" "main" {
#   identifier              = "${var.prefix}-db"
#   allocated_storage       = 20
#   storage_type            = var.storage_type
#   engine                  = var.engine
#   engine_version          = var.engine_version
#   instance_class          = var.instance_class
#   db_subnet_group_name    = aws_db_subnet_group.main.name
#   backup_retention_period = 0
#   multi_az                = false
#   skip_final_snapshot     = true
#   vpc_security_group_ids  = [aws_security_group.rds.id]
#   db_name                 = var.db_name
#   password                = var.db_pass
#   username                = var.db_user

#   tags = {
#     Name = "${var.prefix}-db_instance"
#   }
# }
