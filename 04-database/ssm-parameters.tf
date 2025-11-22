resource "aws_ssm_parameter" "db_end_point" {
  name = "/${var.project_name}/${var.environment}/db_end_point"
  description = "Stores db_end_point for use in other modules"
  type  = "String"
  value = module.db.db_instance_address
  overwrite = true 
}