locals {
  root_dns_records = {
    for domain, details in var.cloudflare_zone_ids : domain => {
      zone_id = details.zone_id
      name    = domain
      type    = "A"
      value   = var.public_ip
    } if details.include_root
  }

  subdomain_dns_records = merge([
    for domain, details in var.cloudflare_zone_ids : {
      for subdomain in details.subdomains : "${subdomain.name}.${domain}" => {
        zone_id = details.zone_id
        name    = "${subdomain.name}.${domain}"
        type    = subdomain.name == "www" ? "CNAME" : "A"
        value   = subdomain.name == "www" ? domain : var.public_ip
      }...
    } if details.include_subdomains
  ]...)

  combined_dns_records = merge(local.root_dns_records, local.subdomain_dns_records)
}

resource "cloudflare_record" "ec2_dns_records" {
  for_each = local.combined_dns_records

  zone_id = each.value.zone_id
  name    = each.value.name
  value   = each.value.value
  type    = each.value.type
  ttl     = 1 // Auto, use a specific TTL if needed
  proxied = false
}
