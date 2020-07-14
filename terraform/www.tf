resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "nli-landing.netlify.com",
  ]
}

resource "aws_route53_record" "www_apex" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "" # apex
  type    = "A"
  ttl     = "300"
  records = [
    # https://docs.netlify.com/domains-https/custom-domains/configure-external-dns/#configure-an-apex-domain
    "104.198.14.52",
  ]
}
