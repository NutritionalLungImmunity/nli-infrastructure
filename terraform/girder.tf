data "local_file" "ssh_public_key" {
  filename = "nli_id_rsa.pub"
}

module "girder" {
  source  = "girder/girder/aws"
  version = "0.4.0"

  project_slug    = "nli-girder"
  subdomain_name  = "data"
  route53_zone_id = aws_route53_zone.domain.zone_id
  ssh_public_key  = data.local_file.ssh_public_key.content
}

output "girder" {
  value = {
    server_fqdn            = module.girder.server_fqdn
    assetstore_bucket_name = module.girder.assetstore_bucket_name
    smtp_host              = module.girder.smtp_host
    smtp_port              = module.girder.smtp_port
    smtp_username          = module.girder.smtp_username
    smtp_password          = module.girder.smtp_password
  }
}
