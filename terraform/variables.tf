variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type = string
}

variable "subnet_cidr" {
    description = "Subnet CIDRS"
    type = list(string)
}

variable "cloudflare_zone_ids" {
  description = "Map of domain to Cloudflare zone IDs, subdomains, service routing, and inclusion flags"
  type = map(object({
    zone_id            = string
    service            = optional(string) # Now optional for root domains
    port               = optional(number) # Now optional for root domains
    subdomains         = list(object({
      name             = string
      service          = string
      port             = number
    }))
    include_root       = bool
    include_subdomains = bool
  }))
  default = {
    "valiantlynx.com" = {
      zone_id = "cc6721eb589ec5e29adc0a306fa5d5fe",
      service = "nginx", # Example service for the root domain
      port    = 80,      # Example port for the root domain
      subdomains = [
        {
          name    = "monitor",
          service = "grafana",
          port    = 3000
        },
        {
          name    = "kuma",
          service = "uptime-kuma",
          port    = 3001
        }
      ],
      include_root = true,
      include_subdomains = true
    }
  }
}
