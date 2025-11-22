data "aws_ssm_parameter" "app_alb_sg_id" {
  # name = "/morrisons/dev/app_alb_sg_id"
    name = "/${var.project_name}/${var.environment}/app_alb_sg_id"
}


data "aws_ssm_parameter" "public_subnet_ids" {
  # name = "/morrisons/dev/bastion_sg_id"
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "app_alb_listener_arn" {
  # name = "/morrisons/dev/app_alb_listener_arn"
    name = "/${var.project_name}/${var.environment}/app_alb_listener_arn"
    depends_on = [aws_ssm_parameter.app_alb_listener_arn  ]
}



data "aws_ami" "openvpn_info" {
    most_recent = true
    owners = ["679593333241"]

    filter {
      name = "state"
      values = ["available"]
    }
    
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
    
    filter {
      name = "name"
      values = ["OpenVPN Access Server Community Image-fe8020db-*"]
    }
   
}


## ami-06e5a963b2dadea6f (openvpn)

# ami-0bdd88bd06d16ba03
# ami-09c813fb71547fc4f ( RHEL-9-DevOps-Practice )