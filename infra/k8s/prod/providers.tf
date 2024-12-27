terraform {
  required_version = ">= 1.8.7"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

// Proxmox
variable "api_url" {
  description = "api url to proxmox"
  type = string
}

variable "proxmox_password" {
  description = "password for proxmox user"
  type = string
}

variable "proxmox_username" {
  description = "username for proxmox user"
  type        = string
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = var.api_url
  pm_password = var.proxmox_password
  pm_user = var.proxmox_username
}