locals {
  # Default versions based on engine type
  mysql_version = "8"
  pg_version    = "15"
  
  # Determine which version to use
  version = var.engine_version != null ? var.engine_version : (
    var.engine == "mysql" ? local.mysql_version : local.pg_version
  )
}

resource "digitalocean_database_cluster" "app_db_cluster" {
  name                 = "${var.name}-db-cluster"
  engine               = var.engine
  version              = local.version
  size                 = var.size
  region               = var.region
  node_count           = var.node_count
  private_network_uuid = var.vpc_uuid

  tags = ["${var.name}-db-cluster"]
}

resource "digitalocean_database_firewall" "app_db_firewall" {
  cluster_id = digitalocean_database_cluster.app_db_cluster.id
  rule {
    type  = "tag"
    value = "web"
  }
}

# resource "digitalocean_database_db" "app_database" {
#   cluster_id = digitalocean_database_cluster.app_db.id
#   name       = var.database_name
# }

# resource "digitalocean_database_user" "app_user" {
#   cluster_id = digitalocean_database_cluster.app_db.id
#   name       = var.user_name
# }