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
      Environment = "dev"
      Terraform = true
      Component = "cdn"
    }

  
}

variable "cdn_tags" {
    type = map(string)
    default = {}
}



variable "zone_name" {
    type = string
    default = "kithusdairy.fun"
  
}


