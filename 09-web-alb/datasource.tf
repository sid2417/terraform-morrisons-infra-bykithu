data "aws_route53_zone" "zone_info" {
    name = "kithusdairy.fun"
    zone_id = "Z02762202XEVMYQ5T1S7K"
   
}

data "aws_ssm_parameter" "web_alb_sg_id" {
  # name = "/morrisons/dev/web_alb_sg_id"
    name = "/${var.project_name}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  # name = "/morrisons/dev/public_subnet_ids"
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  # name = "/morrisons/dev/vpc_id"
    name = "/${var.project_name}/${var.environment}/vpc_id"
}


# data "aws_ssm_parameter" "web_acm_arn" {
#   # name = "/morrisons/dev/web_acm_arn"
#     name = "/${var.project_name}/${var.environment}/web_acm_arn"
# }


