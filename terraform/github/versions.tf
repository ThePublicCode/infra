terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "thepubliccode-tfstate"
    key    = "github/terraform.tfstate"
    region = "auto"

    # R2 does not support these S3 features
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true

    # endpoint passed via -backend-config at init time
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = "ThePublicCode"
}
