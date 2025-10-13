variable "pm_api_url" {
  description = "Proxmox API URL, i.e. https://pve.example.com:8006/api2/json"
  type        = string
}

variable "pm_api_token_id" {
  description = "API token ID, i.e. terraform@pve!infra"
  type        = string
}

variable "pm_api_token_secret" {
  description = "API token secret"
  type        = string
  sensitive   = true
}

variable "node" {
  description = "Proxmox node name"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "recovery_password" {
  description = "root recovery password"
  type        = string
  sensitive   = true
}