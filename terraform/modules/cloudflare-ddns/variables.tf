variable "public_ip" {
  description = "The ip's of the instance."
  type        = list(string)
}

variable "cloudflare_zone_ids" {
  description = "Map of domain to Cloudflare zone IDs, subdomains, and inclusion flags"
  type = map(object({
    zone_id     = string
    subdomains  = list(string)
    include_root = bool
    include_subdomains = bool
  }))
}


