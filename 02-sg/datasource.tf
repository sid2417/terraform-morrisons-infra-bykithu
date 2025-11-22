data "aws_ssm_parameter" "vpc_id" {
  # name = "/morrisons/dev/vpc-id"
    name = "/${var.project_name}/${var.environment}/vpc-id"
}