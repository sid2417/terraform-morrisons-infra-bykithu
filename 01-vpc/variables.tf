variable "common_tags" {
    type = map(string)
    default = {
        Name = "Morrisons"
        Terraform = true
        Environment = "dev"
    
    }
  
}

variable "project_name" {
    type = string
    default = "morrisons"
  
}

variable "environment" {
    type = string
    default = "dev"
}

variable "public_subnets_cidrs" {
    type = list(string)
    default = ["10.0.1.0/24","10.0.2.0/24"]
  
}

variable "private_subnets_cidrs" {
    type = list(string)
    default = ["10.0.10.0/24","10.0.11.0/24"]
  
}

variable "database_subnets_cidrs" {
    type = list(string)
    default = ["10.0.20.0/24","10.0.21.0/24"]
  
}

variable "is_peering_required" {
    type = bool
    default = true
  
}