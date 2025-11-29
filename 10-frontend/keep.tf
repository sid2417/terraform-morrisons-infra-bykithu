# resource "aws_launch_template" "frontend" {
#   name = "frontend"

# #   block_device_mappings {
# #     device_name = "/dev/sdf"

# #     ebs {
# #       volume_size = 20
# #     }
# #   }

# #   capacity_reservation_specification {
# #     capacity_reservation_preference = "open"
# #   }

# #   cpu_options {
# #     core_count       = 4
# #     threads_per_core = 2
# #   }

# #   credit_specification {
# #     cpu_credits = "standard"
# #   }

# #   disable_api_stop        = true
# #   disable_api_termination = true

#   ebs_optimized = true

# #   iam_instance_profile {
# #     name = "test"
# #   }

#   image_id = data.aws_ami.morrisons-ami.value

#   instance_initiated_shutdown_behavior = "terminate"

# #   instance_market_options {
# #     market_type = "spot"
# #   }

#   instance_type = "t3.micro"

# #   kernel_id = "test"

# #   key_name = "test"

# #   license_specification {
# #     license_configuration_arn = data.aws_ssm_parameter.web_acm_arn.value
# #   }

#   metadata_options {
#     http_endpoint               = "enabled"
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 1
#     instance_metadata_tags      = "enabled"
#   }

# #   monitoring {
# #     enabled = true
# #   }

# #   network_interfaces {
# #     associate_public_ip_address = true
# #   }

# #   placement {
# #     availability_zone =  split(",", data.aws_ssm_parameter.public_subnet_ids.value)
# #   }

# #   ram_disk_id = "test"

#   vpc_security_group_ids = [data.web_alb_sg_id.value]

#   tag_specifications {
#     resource_type = "instance"

#     tags = merge(
#           var.common_tags, 
#           var.launch_template_tags, 
#           {Name = "${var.project_name}-${var.environment}"}
#     )
#   }

#   # user_data = filebase64("${path.module}/example.sh")
# }




# resource "aws_lb_target_group" "frontend" {
#   name        = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
#   #target_type = "instance"  
#   port        = 80
#   protocol    = "HTTP"
#   #ip_address_type = "ipv4"
#   #vpc_id      = data.aws_ssm_parameter.vpc_id.value
  

#   health_check {
#     #enabled = true
#     healthy_threshold = 2 ## default is 3   ### range 2 to 10
#     #interval = 30  ## Default is 30.
#     path = "/"
#     port = "80"
#     protocol = "HTTP"
#     #timeout = 5
#     unhealthy_threshold = 2 ##Defaults to 3.
#     matcher  = "200-299"
#   }
  
# }


# resource "aws_autoscaling_group" "frontend" {
#   name                      = "${var.project_name}-${var.environment}-frontend"
#   desired_capacity          = 1
#   max_size                  = 5
#   min_size                  = 1

#   vpc_zone_identifier        = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

#   launch_template {
#     id      = aws_launch_template.frontend.id
#     name = aws_launch_template.frontend.name
#     version = aws_launch_template.frontend.latest_version   ## "$Latest"
#   }


#   tag {
#     key                 = "Name"
#     value               = "${var.project_name}-${var.environment}-frontend"
#     propagate_at_launch = true
#   }


#   instance_refresh {
#     strategy = "Rolling"
#     preferences {
#       min_healthy_percentage = 50
#     }
#     triggers = ["launch_template"]  # Must be list of strings
#   }

#   health_check_type         = "ELB"
#   health_check_grace_period = 60
  
#   force_delete              = true

#   termination_policies = ["OldestLaunchTemplate"]  # Must be list of strings

#   capacity_reservation_specification {
#     capacity_reservation_preference = "default"
#   }

# }



# resource "aws_autoscaling_policy" "frontend" {
#   name                   = "${var.project_name}-${var.environment}-frontend"
#   autoscaling_group_name = aws_autoscaling_group.frontend.name
#   #scaling_adjustment     = 4
#   #adjustment_type        = "ChangeInCapacity"
#   #cooldown               = 300
#   policy_type            = "TargetTrackingScaling"
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }

#     target_value = 40.0
#   }
# #   predictive_scaling_configuration {
# #     metric_specification {
# #       target_value = 50
# #       predefined_load_metric_specification {
# #         predefined_metric_type = "ASGTotalCPUUtilization"

# #           }
# #         }
# #     }
# }
  
