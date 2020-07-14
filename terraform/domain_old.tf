resource "aws_route53_zone" "domain_old" {
  name = "computational-biology.org"
}

resource "aws_route53_record" "domain_old_mailman_mx" {
  zone_id = aws_route53_zone.domain_old.id
  name    = "" # apex
  type    = "MX"
  ttl     = "300"
  records = [
    "10 66.194.253.19", # public.kitware.com
  ]
}

resource "aws_route53_record" "domain_old_web" {
  zone_id = aws_route53_zone.domain_old.zone_id
  name    = "mail"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "public.kitware.com"
  ]
}
