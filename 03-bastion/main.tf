module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]  # This is List
  instance_type = "t3.micro"

  # convert StringList to list and get first element
  subnet_id     = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value), 0) 
  ami = data.aws_ami.morrisons-ami.id
  user_data = file("bastion.sh")
  tags = merge(
          var.common_tags, 
          var.bastion_tags, 
          {Name = "${var.project_name}-${var.environment}-bastion"}
  )
}

#{ Name = "${var.project_name}-${var.environment}-bastion" }


