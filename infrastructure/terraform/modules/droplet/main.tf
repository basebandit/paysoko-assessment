locals {
  droplet_names = length(var.droplet_names) == 0 ? [var.name] : var.droplet_names
}

resource "digitalocean_droplet" "app_server" {
  count    = length(local.droplet_names)
  name     = local.droplet_names[count.index]
  size     = var.size
  image    = var.image
  region   = var.region
  ssh_keys = var.ssh_key_ids
  vpc_uuid = var.vpc_uuid

  tags      = var.tags
  user_data = var.userdata != "" ? var.userdata : null
  lifecycle {
    create_before_destroy = true
  }
}
