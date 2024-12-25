terraform {
  required_version = ">= 1.8.7"
  required_providers {
    porkbun = {
      source = "cullenmcdermott/porkbun"
      version = "0.3.0"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.7.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}

variable "porkbun_secret_key" {
  type = string
  description = "Porkbun secret key"
}

variable "porkbun_api_key" {
  type = string
  description = "Porkbun secret key"
}

provider "porkbun" {
  api_key    = var.porkbun_api_key
  secret_key = var.porkbun_secret_key
}

variable "vault_address" {
  default = "https://openbao.hnatekmar.xyz"
  type = string
}

variable "vault_token" {
  type = string
}

provider "vault" {
  address = var.vault_address
  token    = var.vault_token
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

# Common setup
variable "ssh_private_key" {
  default = "~/.ssh/id_rsa"
  type    = string
}