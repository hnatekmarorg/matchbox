resource "vault_token" "squid" {
  policies = [vault_policy.server_ro.name]
  depends_on = [porkbun_dns_record.ingress]
  ttl = "4h"
}

resource "porkbun_dns_record" "squid" {
  content = "172.16.100.61"
  domain  = "hnatekmar.xyz"
  name = "squid"
  type    = "A"
}

resource "proxmox_vm_qemu" "squid" {
  tags = "terraform"
  depends_on = [proxmox_vm_qemu.matchbox]
  name = "squid.hnatekmar.xyz"
  target_node = "balteus"
  pxe = true
  memory = 8096
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
    macaddr = "BC:24:11:CF:06:21"
  }

  provisioner "file" {
    connection {
      host = "172.16.100.61"
      user = "root"
      type = "ssh"
      private_key = file(var.ssh_private_key)
    }
    destination = "/root/.vault-token"
    content     = vault_token.squid.client_token
  }
}
