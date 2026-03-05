variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for thepubliccode.org"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Root domain"
  type        = string
  default     = "thepubliccode.org"
}
