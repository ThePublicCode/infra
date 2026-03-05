# GitHub Pages DNS records for thepubliccode.org
# https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site

# Apex domain → GitHub Pages IPs
resource "cloudflare_record" "apex" {
  for_each = toset([
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ])

  zone_id = var.cloudflare_zone_id
  name    = "@"
  content = each.value
  type    = "A"
  proxied = false
  ttl     = 1 # auto
}

# www CNAME → GitHub Pages
resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  content = "thepubliccode.github.io"
  type    = "CNAME"
  proxied = false
  ttl     = 1 # auto
}

# staging CNAME → GitHub Pages
resource "cloudflare_record" "staging" {
  zone_id = var.cloudflare_zone_id
  name    = "staging"
  content = "thepubliccode.github.io"
  type    = "CNAME"
  proxied = true # must be proxied for transform rules
  ttl     = 1    # auto
}

# Domain verification TXT record
resource "cloudflare_record" "github_pages_verification" {
  zone_id = var.cloudflare_zone_id
  name    = "_github-pages-challenge-ThePublicCode"
  content = var.github_pages_verification_code
  type    = "TXT"
  ttl     = 1 # auto
}
