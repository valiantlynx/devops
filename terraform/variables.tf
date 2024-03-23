variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type = string
}

variable "subnet_cidr" {
    description = "Subnet CIDRS"
    type = list(string)
}


variable "cloudflare_zone_ids" {
  description = "Map of domain to Cloudflare zone IDs, subdomains, and inclusion flags"
  type = map(object({
    zone_id     = string
    subdomains  = list(string)
    include_root = bool
    include_subdomains = bool
  }))
  default = {
    "valiantlynx.com" = {
      zone_id = "cc6721eb589ec5e29adc0a306fa5d5fe",
      subdomains = ["monitor", "kuma"],
      include_root = false,
      include_subdomains = true
    }
  }
}
