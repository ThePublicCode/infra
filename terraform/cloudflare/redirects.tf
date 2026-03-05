# Transform Rule: rewrite staging.thepubliccode.org URI path
# Prepends /staging to the URI so GitHub Pages serves the correct directory
resource "cloudflare_ruleset" "staging_transform" {
  zone_id = var.cloudflare_zone_id
  name    = "Staging URI rewrite"
  kind    = "zone"
  phase   = "http_request_transform"

  rules {
    action = "rewrite"
    action_parameters {
      uri {
        path {
          expression = "concat(\"/staging\", http.request.uri.path)"
        }
      }
    }
    expression  = "(http.host eq \"staging.${var.domain}\")"
    description = "Prepend /staging to URI for staging subdomain"
    enabled     = true
  }
}
