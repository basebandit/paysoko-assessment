variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "do_spaces_access_key_id" {
  description = "DigitalOcean Spaces Access Id"
  type        = string
  sensitive   = true
}

variable "do_spaces_access_key_secret" {
  description = "DigitalOcean Spaces Access Key"
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "SSH key for Droplet access"
  type        = string
}

variable "vpc_name" {
  description = "Infrastructure project name"
  type        = string
  default     = "paysoko-assessment"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1" #frankfurt1
}

variable "bastion_name" {
  description = "Name of the jump box droplet"
  type        = string
  default     = "app-webserver"
}

variable "ip_range" {
  description = "IP range for VPC"
  type        = string
  default     = "10.10.1.0/24"
}

variable "droplet_size" {
  description = "Size of droplet to create"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "droplet_count" {
  description = "Number of droplets to create"
  type        = number
  default     = 5
}

variable "do_bucket_name" {
  description = "Name of the state bucket"
  type        = string
}

# Server configuration variables
variable "php_version" {
  description = "PHP version to install"
  type        = string
  default     = "8.2"
}

variable "nodejs_version" {
  description = "Node.js version to install"
  type        = string
  default     = "18"
}

