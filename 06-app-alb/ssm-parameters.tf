resource "aws_ssm_parameter" "app_alb_listener_http" {
  name = "/${var.project_name}/${var.environment}/app_alb_listener_http"
  description = "Stores app_alb_listener_http for use in other modules"
  type  = "String"
  value = aws_lb_listener.app_alb_listener_http.arn
  overwrite = true 
}