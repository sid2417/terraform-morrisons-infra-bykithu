resource "aws_acm_certificate" "morrisons" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = merge(
          var.common_tags, 
          var.acm_tags, 
          {Name = "${var.project_name}-${var.environment}"}
    )
}


resource "aws_route53_record" "morrisons" {
  for_each = {
    for dvo in aws_acm_certificate.morrisons.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_info.id
}


resource "aws_acm_certificate_validation" "morrisons" {
  certificate_arn         = aws_acm_certificate.morrisons.arn
  validation_record_fqdns =  [
    for record in aws_route53_record.morrisons : record.fqdn
  ]
}