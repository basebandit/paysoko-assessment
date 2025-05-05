variable "do_token" {
  description = "DigitalOcean API token"
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

variable "droplet_count" {
  description = "Number of droplets to create"
  type        = number
  default     = 5
}
