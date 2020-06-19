resource "aws_route53_record" "girder_old" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "data-old"
  type    = "A"
  ttl     = "300"
  records = ["3.226.111.160"]
}
