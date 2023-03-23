###################################################################
#            # Database/Private subnet # #                        #
#            --------------------------------                     #
# Resources             Name             Number                   #
# ---------           | -------        | ------                   #
# Subnet group        |  main          |   1                      #
# Security group      |  rds           |   1                      #
# Database instance   |  main          |   1                      #
#                     |                |                          #
###################################################################

resource "aws_db_subnet_group" "main" {
  name = "${var.prefix}-main"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "${var.prefix}-db_subnet_group"
  }
}

resource "aws_security_group" "rds" {
  description = "Allow access to the RDS database instance."
  name        = "${var.prefix}-rds-inbound-access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432
    # security_groups = [
    #   aws_security_group.bastion_network_access.id, aws_security_group.ecs_service.id,
    # ]
  }
 tags = {
  Name = "${var.prefix}-security-group-RDS"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "${var.prefix}-db"
  allocated_storage       = 20
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.main.name
  backup_retention_period = 0
  multi_az                = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_name                 = var.db_name
  password                = var.db_pass
  username                = var.db_user

  tags = {
    Name = "${var.prefix}-db_instance"
  }
}
