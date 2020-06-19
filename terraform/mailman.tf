### External Kitware-managed Mailman ###
resource "aws_route53_record" "mailman_mx" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "" # apex
  type    = "MX"
  ttl     = "300"
  records = [
    "10 66.194.253.19", # public.kitware.com
  ]
}

resource "aws_route53_record" "mailman_web" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "mail"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "public.kitware.com"
  ]
}
