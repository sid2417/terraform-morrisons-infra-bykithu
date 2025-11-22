module "db" {
    source = "../../terraform-sg-bykithu" 
    #source = "git::https://github.com/sid2417/terraform-sg-bykithu.git?ref=main"
    #vpc_id = "/${var.project_name}/${var.environment}/vpc-id"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_description = "SG for DB MySQL Instances"
    common_tags = var.common_tags
    sg_name = "db"
   

    # ingress_block =  {
    # ssh = {
    # from_port        = 22
    # to_port          = 22
    # protocol         = "tcp"
    # cidr_blocks      = ["0.0.0.0/0"]
    # }
    # http = {
    # from_port        = 80
    # to_port          = 80
    # protocol         = "tcp"
    # cidr_blocks      = ["0.0.0.0/0"]
    # }
    # https = {
    # from_port        = 8080
    # to_port          = 8080
    # protocol         = "tcp"
    # cidr_blocks      = ["0.0.0.0/0"]
    # }
    # db = {
    # from_port        = 3306
    # to_port          = 3306
    # protocol         = "tcp"
    # cidr_blocks      = ["0.0.0.0/0"]
    # }
    # }


    # egress_block =  {
    # all_outbound  = {
    # from_port        = 0
    # to_port          = 0
    # protocol         = "-1"
    # cidr_blocks      = ["0.0.0.0/0"]
    # }
    # }
    
}


module "backend" {
    source = "../../terraform-sg-bykithu" 
   # source = "git::https://github.com/sid2417/terraform-sg-bykithu.git?ref=main"
    #vpc_id = "/${var.project_name}/${var.environment}/vpc-id"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_description = "SG for backend  Instances"
    common_tags = var.common_tags
    sg_name = "backend"
}

module "frontend" {
    source = "../../terraform-sg-bykithu" 
    #source = "git::https://github.com/sid2417/terraform-sg-bykithu.git?ref=main"
    #vpc_id = "/${var.project_name}/${var.environment}/vpc-id"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_description = "SG for frontend Instances"
    common_tags = var.common_tags
    sg_name = "frontend"
}


module "bastion" {
    source = "../../terraform-sg-bykithu" 
    #source = "git::https://github.com/sid2417/terraform-sg-bykithu.git?ref=main"
    #vpc_id = "/${var.project_name}/${var.environment}/vpc-id"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_description = "SG for bastion Instances"
    common_tags = var.common_tags
    sg_name = "bastion"
}


module "vpn" {
    source = "../../terraform-sg-bykithu" 
    #source = "git::https://github.com/sid2417/terraform-sg-bykithu.git?ref=main"
    #vpc_id = "/${var.project_name}/${var.environment}/vpc-id"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_description = "SG for vpn Instances"
    common_tags = var.common_tags
    sg_name = "vpn"
    ingress_block = var.vpn_sg_rules
}

module "app_alb" {
    source = "../../terraform-sg-bykithu" 
    #source = "git::https://github.com/sid2417/terraform-sg-bykithu.git?ref=main"
    #vpc_id = "/${var.project_name}/${var.environment}/vpc-id"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_description = "SG for app_alb Instances"
    common_tags = var.common_tags
    sg_name = "app_alb"
    
}

## DB
# DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id  # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

# DB is accepting connections from bastion
resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306  # actually for database aws is not allowing port 22
  to_port           = 3306  # so here bastion is just is checking purpose we are allowing 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}

# DB is accepting connections from vpn
resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306  # actually for database aws is not allowing port 22
  to_port           = 3306  # so here vpn is just is checking purpose we are allowing 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from
  security_group_id = module.db.sg_id
}


## Backend
# Backend is accepting connections from app_alb
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id  # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

# Backend is accepting connections from bastion
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

# Backend is accepting connections from vpn_ssh
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}

# Backend is accepting connections from vpn_http
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from
  security_group_id = module.backend.sg_id
}


## app_alb
# app_alb is accepting connections from frontend
resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id  # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

# app_alb is accepting connections from bastion
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

# app_alb is accepting connections from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

# # Frontend is accepting connections from public
# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"] # Here frontend getting traffic from public
#   security_group_id = module.frontend.sg_id
# }


# # Frontend is accepting connections from bastion
# resource "aws_security_group_rule" "frontend_bastion" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.frontend.sg_id
# }



# Bastion is accepting connections from public
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # here generally we mention our home ip address
  security_group_id = module.bastion.sg_id
}