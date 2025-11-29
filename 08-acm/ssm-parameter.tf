
## FQDN = full domain path to a DNS record (record + zone + root)

resource "aws_ssm_parameter" "web_acm_name" {
  name = "/${var.project_name}/${var.environment}/web_acm_name"
  description = "Stores web_acm_name for use in other modules"
  type  = "String"
  value       = join(",", [for r in aws_route53_record.morrisons : r.fqdn])
  overwrite = true 
}

resource "aws_ssm_parameter" "web_acm_value" {
  name = "/${var.project_name}/${var.environment}/web_acm_value"
  description = "Stores web_acm_value for use in other modules"
  type  = "String"
  value = join(",", [for r in aws_route53_record.morrisons : tolist(r.records)[0]])
  overwrite = true 
}


resource "aws_ssm_parameter" "web_acm_arn" {
  name = "/${var.project_name}/${var.environment}/web_acm_arn"
  description = "Stores web_acm_arn for use in other modules"
  type  = "String"
  value = aws_acm_certificate.morrisons.arn
  overwrite = true 
}


