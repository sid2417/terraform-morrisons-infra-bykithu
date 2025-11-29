resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-web-alb"
  internal           = false ## PUBLIC Load Balancer, Anyone can reach using Public IP
  load_balancer_type = "application" # default value is "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

  enable_deletion_protection = false  # default is false

  # vpc_id = data.aws_ssm_parameter.vpc_id

  # ip_address_type = "ipv4"  

  tags = merge(
          var.common_tags, 
          var.web_alb_tags, 
          {Name = "${var.project_name}-${var.environment}-web-alb"}
    )
}




# resource "aws_lb_listener" "web_alb_listener_http" {
#   load_balancer_arn = aws_lb.web_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/html"
#       message_body = "<h1> This is fixed response from web_alb http </h1>"
#       status_code  = "200"
#     }
#   }
# }




# resource "aws_lb_listener" "web_alb_listener_https" {
#   load_balancer_arn = aws_lb.web_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = data.aws_ssm_parameter.web_acm_arn.value

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/html"
#       message_body = "<h1>This is fixed response from web_alb https </h1>"
#       status_code  = "200"
#     }
#   }
# }



module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name  # this is parent-domain

  records = [
    {
      name    = "web-${var.environment}"  # this is considered as sub-domain
      type    = "A"
      allow_overwrite = true
      alias = {
        name    = aws_lb.web_alb.dns_name
        zone_id = aws_lb.web_alb.zone_id
      }
      
    }
  ]
}