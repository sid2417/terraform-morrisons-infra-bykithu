# first we creating instance 
# Using Null resource we establish the connection and ansible integration
# after this we stop the server
# and we take the ami
# we terminate the server
# creating target groups
# launch template
# autoscaling using launch template

module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.project_name}-${var.environment}-backend"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]  # This is List
  instance_type = "t3.micro"

  # convert StringList to list and get first element
  subnet_id     = element(split(",",data.aws_ssm_parameter.private_subnet_ids.value), 0) 
  ami = data.aws_ami.morrisons-ami.id
  tags = merge(
          var.common_tags, 
          var.backend_tags, 
          {Name = "${var.project_name}-${var.environment}-backend"}
  )
}


resource "null_resource" "backend" {
  
  triggers = {  # this will be triggered everytime instance is created
    instance_id = module.backend.id ## ( instance_id ) ---> Here you mention any name leftside part
  }

  connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.backend.private_ip
        timeout = "30m"  # if your ansible-pull can take longer
    }

  provisioner "file" {  ## file provisioner is useful for copying the files from local to remote server
    source      = "backend.sh"
    destination = "/tmp/backend.sh"
  }


  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/backend.sh",
        "sh /tmp/backend.sh backend dev"
      
    ]
  }
}


resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend.id
  state       = "stopped"
  depends_on = [ null_resource.backend ]
}

resource "aws_ami_from_instance" "backend" {
  name               = "${var.project_name}-${var.environment}-backend"
  source_instance_id = module.backend.id
  depends_on = [ aws_ec2_instance_state.backend ]
}

# ( AWS CLI ) :: aws ec2 terminate-instances --instance-ids <here you mention the id of server>
# in terraform there is no resource to terminate the servers
# we have a resource like create, stop there is no terminate option
# for this ec2 termination we use aws cli command

resource "null_resource" "backend_delete" {
  
  triggers = {
    instance_id = module.backend.id ## ( instance_id ) ---> Here you mention any name leftside part
  }

  connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.backend.private_ip
    }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"
    }

    depends_on = [ aws_ami_from_instance.backend ]
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.project_name}-${var.environment}-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.id

  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


resource "aws_launch_template" "backend" {
  name = "${var.project_name}-${var.environment}-backend"

  image_id = "ami-test"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
          var.common_tags, 
          var.backend_tags, 
          {Name = "${var.project_name}-${var.environment}-backend"}
    )
  }

  
}




resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project_name}-${var.environment}-backend"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns    = aws_lb_target_group.backend.arn
  # launch_configuration      = aws_launch_configuration.foobar.name
  # this is old one ( launch_configuration )

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"   ##This is updating latest instance
  }
  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_ids.value)

   instance_refresh {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-backend"
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