variable "name" {
  description = "Name for the database cluster"
  type        = string
}

variable "engine" {
  description = "Database engine (mysql or pg)"
  type        = string
  validation {
    condition     = contains(["mysql", "pg"], var.engine)
    error_message = "Engine must be either mysql or pg."
  }
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = null # We'll use a dynamic value based on the engine
}

variable "size" {
  description = "Size of the database cluster"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "vpc_uuid" {
  description = "UUID of the VPC to connect to"
  type        = string
  default     = null
}