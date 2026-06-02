resource "aws_acm_certificate" "fileops" {
  domain_name               = "filesops.com"
  subject_alternative_names = ["*.filesops.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

resource "aws_route53_record" "fileops" {
  for_each = {
    for dvo in aws_acm_certificate.fileops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.fileops.zone_id
}

resource "aws_acm_certificate_validation" "fileops" {
  certificate_arn         = aws_acm_certificate.fileops.arn
  validation_record_fqdns = [for record in aws_route53_record.fileops : record.fqdn]
}
