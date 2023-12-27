# resource "aws_db_subnet_group" "database_subnet_group" {
#   subnet_ids = [aws_subnet.private_subnets["Private_Sub_DB_1B"].id, aws_subnet.private_subnets["Private_Sub_DB_1A"].id]
# }

# # resource "aws_rds_cluster" "LabVPCDBCluster" {
# #     cluster_identifier = "labvpcdbcluster"
# #     engine = "aurora-mysql"
# #     engine_version = "5.7.mysql_aurora.2.07.2"
# #     db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
# #     database_name = "Population"
# #     master_username = "admin"
# #     master_password = "testingrdscluster"
# #     vpc_security_group_ids = [module.security-groups.security_group_id["database_sg"]]
# #     apply_immediately = true
# #     skip_final_snapshot = true
# # }

# # # output "database_endpoint" {
# # #     value = aws_db_instance.database_instance.address
# # # }
resource "aws_db_subnet_group" "database_subnet_group" {
  subnet_ids = [aws_subnet.private_subnets["Private_Sub_DB_1A"].id, aws_subnet.private_subnets["Private_Sub_DB_1B"].id]
}

resource "aws_db_instance" "database_instance" {
  identifier              = "database"
  db_name                 = "database_instance"
  engine                  = "mysql"
  instance_class          = "db.t2.small"
  username                = "example"
  password                = "exampleexample"
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids  = [module.security-groups.security_group_id["database_sg"]]
  allocated_storage       = 20
  skip_final_snapshot     = true
  backup_retention_period = 0
}

output "database_endpoint" {
  value = aws_db_instance.database_instance.address
}