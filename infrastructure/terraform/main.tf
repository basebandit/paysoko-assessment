module "app_servers" {
  source = "./modules/droplet"

  droplet_names = [
    "laravel-api-server-${var.region}",
    "nodejs-app1-server-${var.region}",
    "nodejs-app2-server-${var.region}",
    "multi-app-server1-${var.region}",
    "multi-app-server2-${var.region}"
  ]

  size = var.droplet_size
  # userdata    = local.web_init_script
  region      = var.region
  tags        = ["web"]
  vpc_uuid    = digitalocean_vpc.app_network.id
  ssh_key_ids = [data.digitalocean_ssh_key.app.id]
}

module "app_database" {
  source = "./modules/database"

  name       = "app"
  engine     = "pg" # PostgreSQL
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1
  vpc_uuid   = digitalocean_vpc.app_network.id
}

# Create Node.js database and user
resource "digitalocean_database_db" "user_service_db" {
  cluster_id = module.app_database.cluster_id
  name       = var.db_user_service
}

resource "digitalocean_database_user" "user_service_db_user" {
  cluster_id = module.app_database.cluster_id
  name       = var.user_service_db_user
}

# Create Laravel database and user
resource "digitalocean_database_db" "task_service_db" {
  cluster_id = module.app_database.cluster_id
  name       = var.db_task_service
}

resource "digitalocean_database_user" "task_service_db_user" {
  cluster_id = module.app_database.cluster_id
  name       = var.task_service_db_user
}

# Create a firewall
resource "digitalocean_firewall" "web_firewall" {
  name = "web-firewall"

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [digitalocean_vpc.app_network.ip_range]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = [digitalocean_vpc.app_network.ip_range]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = [digitalocean_vpc.app_network.ip_range]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = [digitalocean_vpc.app_network.ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"] # Allow all IPv4 and IPv6 destinations
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"] # Allow all IPv4 and IPv6 destinations
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [digitalocean_vpc.app_network.ip_range]
  }

  # Apply to all app servers
  droplet_ids = module.app_servers.droplet_ids
}

module "bastion" {
  source = "./modules/droplet"

  name        = "bastion-${var.bastion_name}-${var.region}"
  region      = var.region
  tags        = ["web"]
  vpc_uuid    = digitalocean_vpc.app_network.id
  ssh_key_ids = [data.digitalocean_ssh_key.app.id]
}

resource "digitalocean_firewall" "bastion" {
  name        = "${var.bastion_name}-only-ssh-bastion"
  droplet_ids = [module.bastion.droplet_id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"] # TODO: lock down to known ips (vpn)
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "22"
    destination_addresses = [digitalocean_vpc.app_network.ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "25060"
    destination_addresses = [digitalocean_vpc.app_network.ip_range]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = [digitalocean_vpc.app_network.ip_range]
  }
}