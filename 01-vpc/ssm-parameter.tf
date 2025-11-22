resource "aws_ssm_parameter" "vpc_id" {
  #name  = "/morrisons/dev/vpc-id"
  name = "/${var.project_name}/${var.environment}/vpc-id"
  description = "Stores VPC ID for use in other modules"
  type  = "String"
  value = module.morrisons_vpc.main_vpc_id  ## here we are refferring from outputs.tf file terraform-vpc-bykithu
  overwrite = true # By default, Terraform doesn’t overwrite existing SSM parameters (for safety)
}

#["id1","id2"] terraform format
# id1, id2 -> AWS SSM format

resource "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
  description = "Stores public_subnet_ids for use in other modules"
  type  = "StringList"
  value = join(",", module.morrisons_vpc.public_subnet_ids ) # converting list to string list  
  overwrite = true 
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
  description = "Stores private_subnet_ids for use in other modules"
  type  = "StringList"
  value = join(",", module.morrisons_vpc.private_subnet_ids ) # converting list to string list  
  overwrite = true 
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/database_subnet_ids"
  description = "Stores database_subnet_ids for use in other modules"
  type  = "StringList"
  value = join(",", module.morrisons_vpc.database_subnet_ids ) # converting list to string list  
  overwrite = true 
}


resource "aws_ssm_parameter" "database_subnet_group_name" {
  #name  = "/morrisons/dev/vpc-id"
  name = "/${var.project_name}/${var.environment}/database_subnet_group_name"
  description = "Stores database_subnet_group_name for use in other modules"
  type  = "String"
  value = module.morrisons_vpc.database_subnet_group_name  ## here we are refferring from outputs.tf file terraform-vpc-bykithu
  overwrite = true # By default, Terraform doesn’t overwrite existing SSM parameters (for safety)
}