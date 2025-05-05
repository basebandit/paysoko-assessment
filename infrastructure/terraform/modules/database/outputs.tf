output "host" {
  value = digitalocean_database_cluster.app_db_cluster.private_host
}

output "port" {
  value = digitalocean_database_cluster.app_db_cluster.port
}

# output "user" {
#   value = digitalocean_database_user.app_user.name
# }

# output "password" {
#   value = digitalocean_database_user.app_user.password
# }

output "name" {
  value = digitalocean_database_cluster.app_db_cluster.name
}

output "uri" {
  value = digitalocean_database_cluster.app_db_cluster.uri
}

output "cluster_id" {
  value = digitalocean_database_cluster.app_db_cluster.id
}