terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "thepubliccode-tfstate"
    key    = "cloudflare/terraform.tfstate"
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
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
