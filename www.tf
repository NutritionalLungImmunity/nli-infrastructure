### Web root for GitHub Pages ###
resource "aws_route53_record" "fungal_webroot_apex" {
  zone_id = "${aws_route53_zone.fungal.zone_id}"
  name    = "" # apex
  type    = "A"
  ttl     = "300"
  records = [
    # https://help.github.com/en/articles/setting-up-an-apex-domain#configuring-a-records-with-your-dns-provider
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

resource "aws_route53_record" "fungal_webroot" {
  zone_id = "${aws_route53_zone.fungal.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = [
    "lungfungalgrowth.github.io",
  ]
}
