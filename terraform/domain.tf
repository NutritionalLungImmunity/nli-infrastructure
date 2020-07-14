resource "aws_route53_zone" "domain" {
  name = "nutritionallungimmunity.org"
}

resource "aws_route53_zone" "domain_alternate" {
  name = "nutritionallungimmunity.com"
}
