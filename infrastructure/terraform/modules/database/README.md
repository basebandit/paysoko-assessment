# DigitalOcean Database Module

This Terraform module provisions a managed database cluster on DigitalOcean with support for MySQL and PostgreSQL.

## Features

- Automatic version selection based on the engine type
- Configurable size, region, and node count
- Database and user creation
- Firewall configuration

## Usage

### MySQL Example

```hcl
module "mysql_database" {
  source = "./path/to/module"
  
  name          = "app"
  engine        = "mysql"
  # Version will default to "8" for MySQL
  size          = "db-s-1vcpu-1gb"
  region        = "nyc1"
  node_count    = 1
  database_name = "appdb"
  user_name     = "appuser"
  vpc_uuid      = module.vpc.id
}
```

### PostgreSQL Example

```hcl
module "postgres_database" {
  source = "./path/to/module"
  
  name          = "app"
  engine        = "pg"
  # Version will default to "15" for PostgreSQL
  size          = "db-s-1vcpu-1gb"
  region        = "nyc1"
  node_count    = 1
  database_name = "appdb"
  user_name     = "appuser"
  vpc_uuid      = module.vpc.id
}
```

### Specifying a Custom Version

```hcl
module "postgres_database" {
  source = "./path/to/module"
  
  name          = "app"
  engine        = "pg"
  version       = "17"  # Explicitly set the version
  size          = "db-s-1vcpu-1gb"
  region        = "nyc1"
  node_count    = 1
  database_name = "appdb"
  user_name     = "appuser"
  vpc_uuid      = module.vpc.id
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the database cluster | `string` | n/a | yes |
| engine | Database engine (mysql or pg) | `string` | n/a | yes |
| version | Database engine version | `string` | `null` | no |
| size | Size of the database cluster | `string` | n/a | yes |
| region | DigitalOcean region | `string` | n/a | yes |
| node_count | Number of nodes in the cluster | `number` | n/a | yes |
| database_name | Name of the database to create | `string` | n/a | yes |
| user_name | Name of the database user to create | `string` | n/a | yes |
| vpc_uuid | UUID of the VPC to connect to | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| host | Database connection host |
| port | Database connection port |
| user | Database user |
| password | Database password |
| database | Database name |
| uri | Database connection URI |

## Supported Versions

### PostgreSQL
Currently supported PostgreSQL versions on DigitalOcean are:
- 13
- 14
- 15
- 17

### MySQL
Currently supported MySQL version on DigitalOcean is:
- 8