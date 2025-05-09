terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    endpoint                    = "fra1.digitaloceanspaces.com"
    key                         = "terraform.tfstate"
    bucket                      = "paysoko-assessment"
    region                      = "eu-central-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }

  # backend "s3" {
  #   endpoints = {
  #     s3 = "https://fra1.digitaloceanspaces.com.digitaloceanspaces.com"
  #   }

  #   bucket = "terraform.tfstate"
  #   key    = "terraform.tfstate"

  #   # Deactivate a few AWS-specific checks
  #   skip_credentials_validation = true
  #   skip_requesting_account_id  = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   skip_s3_checksum            = true
  #   region                      = "eu-central-1"
  # }
}

provider "digitalocean" {
  token = var.do_token

  spaces_access_id  = var.do_spaces_access_key_id
  spaces_secret_key = var.do_spaces_access_key_secret
}