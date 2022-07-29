#######################################################
###              Public Network                     ###
#######################################################

resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr
  #Necessary so that your database gets a default AWS Endpoint
  ## (ie. vinyl-catalog-db-serverless.c764leaodhg4.eu-central-1.rds.amazonaws.com)
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = local.tags
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags   = local.tags
}

## Defines one of the 3 subnets in a different availability zone (1a)
resource "aws_subnet" "main-public-subnets-1a" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.public_subnet_range
  availability_zone = "eu-central-1a"
  tags              = local.tags
}

## Defines one of the 3 subnets in a different availability zone (1b)
resource "aws_subnet" "main-public-subnets-1b" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.public_subnet_range_2
  availability_zone = "eu-central-1b"
  tags              = local.tags
}

## Defines one of the 3 subnets in a different availability zone (1c)
resource "aws_subnet" "main-public-subnets-1c" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.public_subnet_range_3
  availability_zone = "eu-central-1c"
  tags              = local.tags
}


## Ensures that our new Route Table is the main route table utilized by the VPC
## If this association is not done, the VPC will utilize a default Route Table
## which won't have our Internet Gateway route described below
resource "aws_main_route_table_association" "link-vpc-route-table" {
  vpc_id         = aws_vpc.main-vpc.id
  route_table_id = aws_route_table.public-route-table.id
}

## Define a route in our VPC that allow traffic into the VPC
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    ## Any incoming IPv4 "requests" coming into the VPC go through the Internet Gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = local.tags
}

## Define the security group that will allow us to access the Database
## from Scaleway Kubernetes nodes and our local machine
resource "aws_security_group" "rds" {
  name        = "db_security_group"
  description = "RDS MySQL security group"
  # Link security group to VPC
  vpc_id      = aws_vpc.main-vpc.id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    ## External Connection Port
    from_port   = 3306
    ## Internal MySQL Port
    to_port     = 3306
    protocol    = "tcp"
    ## Expected ouput ["Scaleway IP 1/32", "Scaleway IP 2/32", "Local IP/32"]
    cidr_blocks = flatten([
      ## Whitelist our Scaleway Nodes
      var.scaleway_ips,
      ## Whitelist our local environment IP, so we can open a Database Client
      ## like JetBrains DataGrip, MySQL Workbench and etc...
      [
      "${local.ifconfig_json.ip}/32"
      ]
    ])
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

## Associate our Database Cluster to our Subnets
resource "aws_db_subnet_group" "main-db-subnet-group" {
  name       = "db-subnet-group"
  subnet_ids = [
    aws_subnet.main-public-subnets-1a.id,
    aws_subnet.main-public-subnets-1b.id,
    aws_subnet.main-public-subnets-1c.id
  ]
  tags = local.tags
}

#######################################################
###         Useful Security Groups (optional)       ###
#######################################################

#resource "aws_security_group" "allow_tls" {
#  name        = "allow_tls"
#  description = "Allow TLS inbound traffic"
#  vpc_id      = aws_vpc.main-vpc.id
#
#  ingress {
#    description      = "TLS from VPC"
#    from_port        = 443
#    to_port          = 443
#    protocol         = "tcp"
#    cidr_blocks      = [aws_vpc.main-vpc.cidr_block]
##    ipv6_cidr_blocks = [aws_vpc.main-vpc.ipv6_cidr_block]
#  }
#
#  egress {
#    from_port        = 0
#    to_port          = 0
#    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }
#
#  tags = local.tags
#}

#######################################################
###         Private Network (optional)              ###
#######################################################

#resource "aws_subnet" "main-private-subnets" {
#  vpc_id =  aws_vpc.main-vpc.id
#  cidr_block = var.private_subnet_range
#}
#
#resource "aws_route_table" "private-route-table" {
#  vpc_id = aws_vpc.main-vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.main-nat-gateway.id
#  }
#}
#
#resource "aws_route_table_association" "private-route-table-subnet-association" {
#  subnet_id = aws_subnet.main-private-subnets.id
#  route_table_id = aws_route_table.private-route-table.id
#}
#
##
#resource "aws_eip" "main-nat-eip" {
#  vpc   = true
#}
#
#resource "aws_nat_gateway" "main-nat-gateway" {
#  allocation_id = aws_eip.main-nat-eip.id
#  subnet_id = aws_subnet.main-public-subnets.id
#}