resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "www"
  type    = "A"
  ttl     = "300"
  records = [
    # SiteGround hosting
    "35.208.165.110",
  ]
}

resource "aws_route53_record" "www_apex" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "" # apex
  type    = "A"
  ttl     = "300"
  records = [
    # SiteGround hosting
    "35.208.165.110",
  ]
}
