locals {
  dns_records = tomap(flatten([
    for domain, details in var.cloudflare_zone_ids : [
      // A records for root domain, if included
      if details.include_root {
        "${domain}" = {
          zone_id = details.zone_id,
          name    = domain,
          type    = "A",
          value   = var.public_ip
        }
      },
      // A or CNAME records for subdomains, including a special case for 'www'
      if details.include_subdomains {
        for subdomain in details.subdomains : "${subdomain}.${domain}" = {
          zone_id = details.zone_id,
          name    = "${subdomain}.${domain}",
          type    = subdomain == "www" ? "CNAME" : "A", // Use CNAME for 'www', A for others
          value   = subdomain == "www" ? domain : var.public_ip // Point 'www' to root domain, others to IP
        }
      }
    ]
  ]))
}

resource "cloudflare_record" "ec2_dns_records" {
  for_each = locals.dns_records

  zone_id  = each.value.zone_id
  name     = each.value.name
  value    = each.value.value
  type     = each.value.type
  ttl      = 1 // Auto, use a specific TTL if needed
  proxied  = false
}
