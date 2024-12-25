resource "vault_token" "matchbox" {
  policies = [vault_policy.server_ro.name]
  ttl = "4h"
}

resource "porkbun_dns_record" "matchbox-dns" {
  domain  = "hnatekmar.xyz"
  name = "matchbox"
  type = "A"
  content = "172.16.100.60"
  ttl = "3600"
}

resource "proxmox_vm_qemu" "matchbox" {
  tags = "terraform"
  name = "matchbox.hnatekmar.xyz"
  target_node = "balteus"
  memory = 4096
  cores = 2
  bios = "ovmf"
  boot = "order=scsi0;ide2"
  agent = 0

  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }
  scsihw = "virtio-scsi-pci"
  disks {
    ide {
        ide2 {
          cdrom {
            iso = "local:iso/matchbox-v0.0.25.iso"
          }
        }
    }
    scsi {
      scsi0 {
        disk {
          size    = "16G"
          storage = "iscsi"
        }
      }
    }
  }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  provisioner "file" {
    connection {
      host = "172.16.100.60"
      user = "root"
      type = "ssh"
      private_key = file(var.ssh_private_key)
    }
    destination = "/root/.vault-token"
    content     = vault_token.matchbox.client_token
  }
}
