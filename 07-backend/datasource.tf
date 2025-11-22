data "aws_ssm_parameter" "backend_sg_id" {
  # name = "/morrisons/dev/vpn_sg_id"
    name = "/${var.project_name}/${var.environment}/vpn_sg_id"
}


data "aws_ssm_parameter" "vpc_id" {
  # name = "/morrisons/dev/vpn_sg_id"
    name = "/${var.project_name}/${var.environment}/vpc_id"
}


data "aws_ssm_parameter" "private_subnet_ids" {
  # name = "/morrisons/dev/bastion_sg_id"
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}


data "aws_ami" "morrisons-ami" {
    most_recent = true
    owners = ["973714476881"]

    filter {
      name = "state"
      values = ["available"]
    }
    
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

   
}


## ami-06e5a963b2dadea6f (openvpn)

# ami-0bdd88bd06d16ba03
# ami-09c813fb71547fc4f ( RHEL-9-DevOps-Practice )