resource "aws_route53_record" "viewer" {
  zone_id = aws_route53_zone.domain.zone_id
  name = "viewer"
  type = "CNAME"
  ttl = "300"
  records = [
    "flungui.netlify.com",
  ]
}
