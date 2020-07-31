data "local_file" "ssh_public_key" {
  filename = "nli_id_rsa.pub"
}

module "girder" {
  source  = "girder/girder/aws"
  version = "0.6.0"

  project_slug    = "nli-girder"
  subdomain_name  = "data"
  route53_zone_id = aws_route53_zone.domain.zone_id
  ssh_public_key  = data.local_file.ssh_public_key.content
}

output "girder_server_fqdn" {
  value = module.girder.server_fqdn
}
output "girder_assetstore_bucket_name" {
  value = module.girder.assetstore_bucket_name
}
output "girder_smtp_host" {
  value = module.girder.smtp_host
}
output "girder_smtp_port" {
  value = module.girder.smtp_port
}
output "girder_smtp_username" {
  value = module.girder.smtp_username
}
output "girder_smtp_password" {
  value     = module.girder.smtp_password
  sensitive = true
}
