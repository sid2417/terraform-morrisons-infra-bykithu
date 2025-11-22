output "az_names" {
    value = module.morrisons_vpc.az_info
  
}

output "default_vpc_info" {
    value = module.morrisons_vpc.default_vpc
  
}

output "morrisons_vpc_id" {
    value = module.morrisons_vpc.main_vpc_id
  
}

output "morrisons_public_subnet_ids" {
    value = module.morrisons_vpc.public_subnet_ids
  
}

output "morrisons_private_subnet_ids" {
    value = module.morrisons_vpc.private_subnet_ids
  
}

output "morrisons_database_subnet_ids" {
    value = module.morrisons_vpc.database_subnet_ids
  
}


output "morrisons_database_subnet_group_name" {
    value = module.morrisons_vpc.database_subnet_group_name
  
}

### we are storing key-values in ssm-parameter store


