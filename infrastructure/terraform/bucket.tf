resource "digitalocean_spaces_bucket" "remote_state" {
  name   = var.do_bucket_name
  region = var.region
  acl    = "private"
  versioning {
    enabled = true
  }
}