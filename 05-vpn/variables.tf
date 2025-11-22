variable "project_name" {
    type = string
    default = "morrisons"
  
}

variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    type = map(string)
    default = {
      Project = "morrisons"
      Environment = "Dev"
      Terraform = true
    }

  
}

variable "vpn_tags" {
    type = map(string)
    default = {}
}

variable "public_key_path" {
    type = string
    description = "Path to SSH public key"
    default     = "C:/Users/SIDDHARTHA/Desktop/DevOps/newkeys/kithu.pub"
}



