output "droplet_public_ips" {
  value       = module.app_servers.droplet_public_ips
  description = "The public IPs of the droplets"
}

output "droplet_private_ips" {
  value       = module.app_servers.droplet_private_ips
  description = "The private IPs of the droplets"
}

output "droplet_ids" {
  value       = module.app_servers.droplet_ids
  description = "The public IPs of the droplets"
}

output "bastion_public_ip" {
  value       = module.bastion.droplet_public_ips
  description = "The public IP of the jump box droplet"
}

output "database_host" {
  value       = module.app_database.host
  description = "Database connection host"
}

output "database_port" {
  value       = module.app_database.port
  description = "Database connection port"
}

output "database_name" {
  value       = module.app_database.name
  description = "Database name"
}

output "database_uri" {
  value       = module.app_database.uri
  description = "Database host uri"
  sensitive   = true
}
# Using the private hostname from your terraform output

output "vpc_uuid" {
  value = digitalocean_vpc.app_network.id
}