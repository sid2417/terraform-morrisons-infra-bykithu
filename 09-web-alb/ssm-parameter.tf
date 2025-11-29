resource "aws_ssm_parameter" "web_alb_arn" {
  name = "/${var.project_name}/${var.environment}/web_alb_arn"
  description = "Stores web_alb_arn for use in other modules"
  type  = "String"
  value = aws_lb.web_alb.arn
  overwrite = true 
}


resource "aws_ssm_parameter" "web_alb_listener_http_arn" {
  name = "/${var.project_name}/${var.environment}/web_alb_listener_http_arn"
  description = "Stores web_alb_listener_http_arn for use in other modules"
  type  = "String"
  value = aws_lb_listener.web_alb_listener_http.arn
  overwrite = true 
}


resource "aws_ssm_parameter" "web_alb_listener_https_arn" {
  name = "/${var.project_name}/${var.environment}/web_alb_listener_https_arn"
  description = "Stores web_alb_listener_https_arn for use in other modules"
  type  = "String"
  value = aws_lb_listener.web_alb_listener_https.arn
  overwrite = true 
}