# SSH Key for Droplet access
data "digitalocean_ssh_key" "app" {
  name = var.ssh_key
}