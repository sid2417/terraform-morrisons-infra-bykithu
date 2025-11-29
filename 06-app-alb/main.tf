resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-${var.environment}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.private_subnet_ids.value) 

  enable_deletion_protection = false

  tags = merge(
          var.common_tags, 
          var.app_alb_tags, 
          {Name = "${var.project_name}-${var.environment}-app-alb"}
  )
}



resource "aws_lb_listener" "app_alb_listener_http" {
  load_balancer_arn = aws_lb.app_alb.arn
  # this will work but ssm-parameter and datasource we mention in the same repo becoz of time abiguity datasource not loading
  # it means while storing the value in the ssm-parametrer before only datasource is try to catch the value, so it will not detect the value, we got error
  #load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from APP ALB</h1>"
      status_code  = "200"
    }
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name  # this is parent-domain

  records = [
    {
      name    = "*.app-${var.environment}"  # this is considered as sub-domain
      type    = "A"
      allow_overwrite = true
      alias = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
      
    }
  ]
}