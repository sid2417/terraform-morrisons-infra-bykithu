data "aws_ssm_parameter" "vpc_id" {
  # name = "/morrisons/dev/vpc_id"
    name = "/${var.project_name}/${var.environment}/vpc_id"
}


data "aws_ssm_parameter" "frontend_sg_id" {
  # name = "/morrisons/dev/frontend_sg_id"
    name = "/${var.project_name}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  # name = "/morrisons/dev/public_subnet_ids"
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}



data "aws_ssm_parameter" "web_alb_listener_https_arn" {
  # name = "/morrisons/dev/web_alb_listener_https_arn"
    name = "/${var.project_name}/${var.environment}/web_alb_listener_https_arn"
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



# data "aws_ssm_parameter" "web_acm_arn" {
#   # name = "/morrisons/dev/web_acm_arn"
#     name = "/${var.project_name}/${var.environment}/web_acm_arn"
# }

# data "aws_ssm_parameter" "web_alb_arn" {
#   # name = "/morrisons/dev/web_alb_arn"
#     name = "/${var.project_name}/${var.environment}/web_alb_arn"
# }

# data "aws_ssm_parameter" "web_alb_sg_id" {
#   # name = "/morrisons/dev/web_alb_sg_id"
#     name = "/${var.project_name}/${var.environment}/web_alb_sg_id"
# }





