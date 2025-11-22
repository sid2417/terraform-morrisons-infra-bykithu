module "morrisons_vpc" {
    source = "../../terraform-vpc-bykithu"
    #source = "git::https://github.com/sid2417/terraform-vpc-bykithu.git?ref=main"
    common_tags = var.common_tags
    project_name = var.project_name
    public_subnets_cidrs = var.public_subnets_cidrs
    private_subnets_cidrs = var.private_subnets_cidrs
    database_subnets_cidrs = var.database_subnets_cidrs
    is_peering_required = var.is_peering_required

  
}

## in source = "git::" --> git :: is mandatory to fectch the git repo
## and after ? ref=main is also recommanded for fetching from  particular branch