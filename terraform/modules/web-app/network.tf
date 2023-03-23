################################################################### 
#                 # Inbound & Outbound internet access #          #
#                -----------------------------------------        #
# Resources                  Name                   Number        #
# ---------                | -------              | ------        #
#  VPC                     | main                 |   2           #
#  Internet Gateway        | main                 |   2           #
#  Subnet                  | [public_a,public_b]  |   2           #
#  Route table             |                      |   2           #
#  Route table association |                      |   2           #
#  Route                   |                      |   2           #
#  Nat gateway             |                      |   2           #
#  Eip                     |                      |   2           #
###################################################################
#                 # Outbound internet access #                    #
#                -------------------------------                  #
#                          |                      |               #
#  Subnet                  |[private_a,private_b] |   2           #
#  Route table             |                      |   2           #
#  Route table association |                      |   2           #
#  Route                   |                      |   2           #
###################################################################
#                 # Security groups #                             #
#                -------------------------------                  #
#                        |                         |     #
# Security groups        |  bastion_network_access |   1  
#    -                   |  rds                   |   1  
# Subnet group           |  main                 |  1
###################################################################

resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-main-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

#############################################################
### PUBLIC A ####

resource "aws_subnet" "public_a" {
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${data.aws_region.current.name}a"

  tags = {
    Name = "${var.prefix}-subnet"
  }
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-route-table"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_route" "public_internet_access_a" {
  route_table_id         = aws_route_table.public_a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}


resource "aws_nat_gateway" "public_a" {
  allocation_id = aws_eip.public_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "${var.prefix}-nat-gateway"
  }
}

resource "aws_eip" "public_a" {
  vpc = true

  tags = {
    Name = "${var.prefix}-eip"
  }
}

#############################################################
### PUBLIC B ####

resource "aws_subnet" "public_b" {
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${data.aws_region.current.name}b"

  tags = {
    Name = "${var.prefix}-subnet"
  }
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-route-table"
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_b.id
}

resource "aws_route" "public_internet_access_b" {
  route_table_id         = aws_route_table.public_b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_eip" "public_b" {
  vpc = true

  tags = {
    Name = "${var.prefix}-eip"
  }
}

resource "aws_nat_gateway" "public_b" {
  allocation_id = aws_eip.public_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "${var.prefix}-nat-gateway"
  }
}


#############################################################
#### PRIVATE A ####

resource "aws_subnet" "private_a" {
  cidr_block        = "10.1.10.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "${var.prefix}-subnet"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-route-table"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route" "private_a_internet_out" {
  route_table_id         = aws_route_table.private_a.id
  nat_gateway_id         = aws_nat_gateway.public_a.id
  destination_cidr_block = "0.0.0.0/0"
}

#############################################################
#### PRIVATE B ####

resource "aws_subnet" "private_b" {
  cidr_block        = "10.1.11.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Name = "${var.prefix}-subnet"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-route-table"
  }
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route" "private_b_internet_out" {
  route_table_id         = aws_route_table.private_b.id
  nat_gateway_id         = aws_nat_gateway.public_b.id
  destination_cidr_block = "0.0.0.0/0"
}

############
#Security Groups

##
#bastion

resource "aws_security_group" "bastion_network_access" {
  name        = "${var.prefix}-bastion-network-access"
  description = "security group that allows ssh and inbound and outbound traffic"
  vpc_id      = aws_vpc.main.id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #POSTGRES
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_a.cidr_block, aws_subnet.private_b.cidr_block]
  }

  tags = {
    Name = "${var.prefix}-bastion-network-access"
  }
}




########
#db
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
    #TODO: REMOVE THAT LINE BELOW WHEN ECS IS COMPLETED
    security_groups = [
      aws_security_group.bastion_network_access.id
    ]
    #FINAL LINE WHEN ECS IS COMPLETED
    # security_groups = [
    #   aws_security_group.bastion_network_access.id, aws_security_group.ecs_service.id,
    # ]
  }
  tags = {
    Name = "${var.prefix}-security-group-RDS"
  }
}