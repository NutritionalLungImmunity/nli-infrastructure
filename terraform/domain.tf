resource "aws_route53_zone" "domain" {
  name = "nutritionallungimmunity.org"
}

resource "aws_route53_zone" "domain_alternate" {
  name = "nutritionallungimmunity.com"
}

resource "aws_route53_record" "worker" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "worker"
  type    = "A"
  ttl     = "300"
  records = [
    aws_eip.worker.public_ip
  ]
}
