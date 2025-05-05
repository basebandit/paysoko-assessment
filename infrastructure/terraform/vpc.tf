resource "digitalocean_vpc" "app_network" {
  name     = "${var.vpc_name}-vpc"
  region   = var.region
  ip_range = var.ip_range
}