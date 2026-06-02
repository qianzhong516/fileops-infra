resource "aws_route53_record" "db_dev" {
  zone_id = data.aws_route53_zone.fileops.zone_id
  name    = "db.dev.filesops.com"
  type    = "CNAME"
  ttl     = 5
  records = [module.rds.db_instance_address]
}
