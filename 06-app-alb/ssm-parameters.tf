resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name = "/${var.project_name}/${var.environment}/app_alb_listener_arn"
  description = "Stores app_alb_listener_arn for use in other modules"
  type  = "String"
  value = aws_lb.app_alb.arn
  overwrite = true 
}