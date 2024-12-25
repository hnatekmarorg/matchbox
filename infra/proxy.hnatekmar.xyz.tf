
resource "vault_token" "proxy" {
  policies = [vault_policy.server_ro.name, vault_policy.caddy_ro.name]
  depends_on = [porkbun_dns_record.ingress, proxmox_vm_qemu.proxy]
  renewable = true
  ttl = "7h"
  num_uses = 500

  renew_min_lease = 43200
  renew_increment = 86400
  provisioner "file" {
    connection {
      host = "172.16.100.63"
      user = "root"
      type = "ssh"
      private_key = file(var.ssh_private_key)
    }
    destination = "/root/.vault-token"
    content     = vault_token.proxy.client_token
  }

}

resource "porkbun_dns_record" "proxy" {
  content = "172.16.100.63"
  domain  = "hnatekmar.xyz"
  name = "proxy"
  type    = "A"
}

resource "proxmox_vm_qemu" "proxy" {
  tags = "terraform"
  depends_on = [proxmox_vm_qemu.matchbox]
  name = "proxy.hnatekmar.xyz"
  target_node = "balteus"
  pxe = true
  memory = 4096
  cores = 2
  bios = "ovmf"
  boot = "order=scsi0;net0"
  agent = 0

  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }
  scsihw = "virtio-scsi-pci"
  disks {
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
    macaddr = "52:E9:54:14:30:FA"
  }

  network {
    id = 1
    model = "virtio"
    bridge = "vmbr2"
  }

}
