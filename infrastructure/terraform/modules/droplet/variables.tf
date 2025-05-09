# variable "droplet_count" {
#   description = "Number of droplets to create"
#   type        = number
# }

variable "droplet_names" {
  description = "(Optional) List of droplet names. Use this when creating multiple droplets."
  type        = list(string)
  default     = []
}

variable "tags" {
 description = "Tags to identify droplets"
 type = list(string)
 default = []
}

variable "image" {
  description = "OS to install on the droplets"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "name"{
  description = "(Optional) Name of a single droplet. Set this when you only want to create one droplet."
  type = string
  default = ""
}

variable "userdata"{
  description = "Cloud init config file"
  type = string
  default = ""
}

variable "size" {
  description = "Size of droplet to create"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
}

variable "ssh_key_ids" {
  description = "List of SSH key IDs"
  type        = list(string)
}

variable "vpc_uuid" {
  description = "DigitalOcean vpc unique identifier"
  type        = string
}