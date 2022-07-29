resource "aws_rds_cluster" "main-db" {
  cluster_identifier      = "${var.project_name}-db"
  ## Defines engine DB we want to use (other possible values: aurora-postgresql, aurora)
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  availability_zones      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  database_name           = "vinyl_catalog"
  master_username         = "admin"
  master_password         = random_password.rds-master-password.result
  engine_version          = "8.0.mysql_aurora.3.02.0"

  ## Defines scaling capacities
  serverlessv2_scaling_configuration {
    min_capacity = 0.5 ## 1 GiB
    max_capacity = 1.0 ## 2 GiB
  }

  #### Uncomment if you want to enable support for Multi-AZ
  #  db_cluster_instance_class = "db.t3"
  #  storage_type              = "io1"
  #  allocated_storage         = 100
  #  iops                      = 1000

  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main-db-subnet-group.name
  tags                   = local.tags
}


resource "aws_rds_cluster_instance" "main-db-serverless-instance" {
  identifier          = "${var.project_name}-db-serverless"
  cluster_identifier  = aws_rds_cluster.main-db.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.main-db.engine
  engine_version      = aws_rds_cluster.main-db.engine_version
  publicly_accessible = true
  ## Enable statistics on usage of the instance (cost extra $)
  #performance_insights_enabled = true
}


#resource "aws_rds_cluster" "main-db" {
#  cluster_identifier      = "${var.project_name}-db"
#  ## Defines engine DB we want to use (other possible values: aurora-postgresql, aurora)
#  engine                  = "aurora-mysql"
#  ## Serverless mode (no need for DB instance)
#  engine_mode             = "serverless"
#  availability_zones      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
#  database_name           = "vinyl_catalog"
#  master_username         = "admin"
#  master_password         = random_password.rds-master-password.result
#  engine_version          = "5.7.mysql_aurora.2.07.1"
#
#  ## Defines scaling capacities
#  scaling_configuration {
#    ## Enable auto-pause of the instance if not in use
#    auto_pause               = true
#    min_capacity             = 1 ## 2GiB RAM
#    max_capacity             = 2 ## 4GiB RAM
#    ## After 5min of no transactions or long-running queries it auto-pause
#    seconds_until_auto_pause = 300
#    timeout_action           = "ForceApplyCapacityChange"
#  }
#
#  skip_final_snapshot    = true
#  vpc_security_group_ids = [aws_security_group.rds.id]
#  db_subnet_group_name   = aws_db_subnet_group.main-db-subnet-group.name
#  tags                   = local.tags
#}

