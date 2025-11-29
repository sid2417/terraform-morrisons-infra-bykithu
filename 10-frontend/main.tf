# first we creating instance 
# Using Null resource we establish the connection and ansible integration
# after this we stop the server
# and we take the ami
# we terminate the server
# creating target groups
# launch template
# autoscaling using launch template

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]  # This is List
  instance_type = "t3.micro"

  # convert StringList to list and get first element
  subnet_id     = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value), 0) 
  ami = data.aws_ami.morrisons-ami.id
  tags = merge(
          var.common_tags, 
          var.frontend_tags, 
          {Name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"}
  )
}


resource "null_resource" "frontend" {
  
  triggers = {  # this will be triggered everytime instance is created
    instance_id = module.frontend.id ## ( instance_id ) ---> Here you mention any name leftside part
  }

  connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.frontend.private_ip
        #timeout = "30m"  # if your ansible-pull can take longer
    }

  provisioner "file" {  ## file provisioner is useful for copying the files from local to remote server
    source      = "${var.common_tags.Component}.sh"
    destination = "/tmp/${var.common_tags.Component}.sh"
  }


  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/${var.common_tags.Component}.sh",
        "sudo sh /tmp/${var.common_tags.Component}.sh ${var.common_tags.Component} ${var.environment}"
      
    ]
  }
}




resource "aws_ec2_instance_state" "frontend" {
  instance_id = module.frontend.id
  state       = "stopped"
  depends_on = [ null_resource.frontend ]  # stop the serever only when null resource provisioning is completed
}

resource "aws_ami_from_instance" "frontend" {
  name               = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  source_instance_id = module.frontend.id
  depends_on = [ aws_ec2_instance_state.frontend ]
}

# ( AWS CLI ) :: aws ec2 terminate-instances --instance-ids <here you mention the id of server>
# in terraform there is no resource to terminate the servers
# we have a resource like create, stop there is no terminate option
# for this ec2 termination we use aws cli command

resource "null_resource" "frontend_delete" {
  
  triggers = {  # this will be triggered everytime instance is created
    instance_id = module.frontend.id ## ( instance_id ) ---> Here you mention any name leftside part
  }

  # connection {
  #       type     = "ssh"
  #       user     = "ec2-user"
  #       password = "DevOps321"
  #       host     = module.frontend.private_ip
  #   }

  # provisioner "local-exec" {
  #   command = "aws ec2 terminate-instances --instance-ids \"${module.frontend.id}\""
  #   environment = {
  #       AWS_DEFAULT_REGION = "us-east-1"
  #     }
  #   }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend.id} --region us-east-1 --output json"
  }

  depends_on = [ aws_ami_from_instance.frontend ]
}

resource "aws_lb_target_group" "frontend" {
  name     = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}


resource "aws_launch_template" "frontend" {
  name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"

  image_id = aws_ami_from_instance.frontend.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  update_default_version = true # sets the latest version to default

  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
          var.common_tags, 
          var.frontend_tags, 
          {Name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"}
    )
  }

  
}




resource "aws_autoscaling_group" "frontend" {
  name                      = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns    = [aws_lb_target_group.frontend.arn]
  # launch_configuration      = aws_launch_configuration.foobar.name
  # this is old one ( launch_configuration )

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"   ##This is updating latest instance
  }
  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

   instance_refresh {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

 

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = "${var.project_name}"
    propagate_at_launch = false
  }
}



resource "aws_autoscaling_policy" "frontend" {
  name  = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10.0  ## for checking and practice purpose we mention 10 otherwise the cpu utilization is more than 60 or 70 percentage
  }
}


resource "aws_lb_listener_rule" "frontend" {
  listener_arn = data.aws_ssm_parameter.web_alb_listener_https_arn.value
  priority     = 100 # less number will be first validated

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["web-${var.environment}.${var.zone_name}"]
    }
  }
}
