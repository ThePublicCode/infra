terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "thepubliccode-tfstate"
    key    = "cloudflare/terraform.tfstate"
    region = "auto"

    # Cloudflare R2 S3-compatible endpoint
    endpoints = {
      s3 = "https://<ACCOUNT_ID>.r2.cloudflarestorage.com"
    }

    # R2 does not support these S3 features
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
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
