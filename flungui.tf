provider "netlify" {
  # TODO: pass this via env NETLIFY_TOKEN
  token = "" # TODO: secret
}

locals {
  subdomain_name = "viewer"
}

resource "netlify_site" "fungal_flungui" {
  name = "flungui"
  repo {
    provider = "github"
    repo_path = "LungFungalGrowth/lung-fungal-web"
    repo_branch = "master"

    command = "yarn run build"
    dir = "/dist"
  }
  # Strip the trailing dot from the zone name
  custom_domain = "${local.subdomain_name}.${replace(aws_route53_zone.fungal.name, "/[.]$/", "")}"
}

resource "aws_route53_record" "fungal_flungui" {
  zone_id = "${aws_route53_zone.fungal.zone_id}"
  name = "${local.subdomain_name}"
  type = "CNAME"
  ttl = "300"
  records = [
    "${netlify_site.fungal_flungui.name}.netlify.com",
  ]
}
