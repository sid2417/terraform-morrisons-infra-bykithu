data "aws_cloudfront_cache_policy" "cache_enable" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "cache_disable" {
  name = "Managed-CachingDisabled"
}


data "aws_ssm_parameter" "web_acm_arn" {
  name = "/${var.project_name}/${var.environment}/web_acm_arn"
}