variable "github_token" {
  description = "GitHub PAT with repo and admin scopes for ThePublicCode org"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization name"
  type        = string
  default     = "ThePublicCode"
}
