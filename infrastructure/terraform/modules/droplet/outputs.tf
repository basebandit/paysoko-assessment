output "droplet_public_ips" {
  description = "IPv4 Address of multiple droplets"
  value = {
    for i, droplet in digitalocean_droplet.app_server :
    droplet.name => droplet.ipv4_address
  }
}

output "droplet_private_ips" {
  description = "IPv4 Address of multiple droplets"
  value = {
    for i, droplet in digitalocean_droplet.app_server :
    droplet.name => droplet.ipv4_address_private
  }
}

output "droplet_ids" {
  value = digitalocean_droplet.app_server[*].id
}

output "droplet_id" {
  value       = length(var.droplet_names) == 0 ? digitalocean_droplet.app_server[0].id : null
  description = "ID of the single droplet"
}

output "droplet_urns" {
  value = [for droplet in digitalocean_droplet.app_server : droplet.urn]
}
