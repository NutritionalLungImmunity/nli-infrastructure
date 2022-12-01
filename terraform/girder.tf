data "local_file" "ssh_public_key" {
  filename = "nli_id_rsa.pub"
}

module "girder3" {
  source  = "girder/girder3/aws"
  version = "0.11.1"

  project_slug    = var.project_slug
  subdomain_name  = "data"
  route53_zone_id = aws_route53_zone.domain.zone_id
  ssh_public_key  = data.local_file.ssh_public_key.content
}
moved {
  from = module.girder
  to   = module.girder3
}

variable "project_slug" {
  type    = string
  default = "nli-girder"
}

output "girder_server_fqdn" {
  value = module.girder3.server_fqdn
}
output "girder_assetstore_bucket_name" {
  value = module.girder3.assetstore_bucket_name
}
output "girder_smtp_host" {
  value = module.girder3.smtp_host
}
output "girder_smtp_port" {
  value = module.girder3.smtp_port
}
output "girder_smtp_username" {
  value = module.girder3.smtp_username
}
output "girder_smtp_password" {
  value     = module.girder3.smtp_password
  sensitive = true
}
