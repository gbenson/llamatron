variable "project_codename" {
  description = "Internal name of this project or deployment"
  type        = string
  sensitive   = true
}

variable "admin_ip_prefix" {
  description = "CIDR from which administration may be performed"
  type        = string
  sensitive   = true
}

variable "admin_ssh_key" {
  description = "SSH public key for server admin"
  type        = string
  sensitive   = true
}
