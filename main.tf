# NOTE: LIBVIRT_DEFAULT_URI needs to be set, probably to qemu:///session (validate with 'virsh uri' command)
provider "libvirt" {
  #uri = "qemu:///session"
  uri = "qemu:///session?socket=/Users/mtrachier/.cache/libvirt/libvirt-sock"
}

locals {
  network_config = yamlencode({
    network = {
      version = 1
      config = [{
        type = "physical"
        name = "eth0"
        subnets = [{
          type = "dhcp"
        }]
      }]
    }
  })
  user_data = yamlencode({
    users = [{
      name = "root"
      ssh_authorized_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGbArPa8DHRkmnIx+2kT/EVmdN1cORPCDYF2XVwYGTsp matt.trachier@suse.com"]
    }]
    chpasswd = {
      list = ["root:linux"]
    }
    disable_root = false
    growpart = {
      mode = "auto"
      devices = ["/"]
    }
    runcmd = [
      "sed  -i '/PermitRootLogin/s/.*/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "systemctl restart sshd",
    ]
  })
  image = "/Users/mtrachier/QEMU/jammy-server-cloudimg-arm64.img"
  name = "U22Arm9"
  emulator = "/opt/homebrew/bin/qemu-system-aarch64"
  firmware = "/Users/mtrachier/QEMU/aarch64-QEMU_EFI.fd"
}

# A pool for all cluster volumes
resource "libvirt_pool" "storage" {
  name = "initial"
  type = "dir"
  path = "/Users/mtrachier/libvirtdata"
}

resource "libvirt_volume" "boot" {
  depends_on = [
    libvirt_pool.storage,
  ]
  name   = "boot"
  source = local.image
  pool   = "initial"
}

resource "libvirt_volume" "data" {
  depends_on = [
    libvirt_pool.storage,
    libvirt_volume.boot,
  ]
  name           = "data"
  base_volume_id = libvirt_volume.boot.id
  pool           = "initial"
  size           = 15 * 1073741824 # calculate G size in B
}

resource "libvirt_cloudinit_disk" "init" {
  depends_on = [
    libvirt_pool.storage,
    libvirt_volume.boot,
    libvirt_volume.data,
  ]
  name           = "cloudinit.iso"
  user_data      = local.user_data
  network_config = local.network_config
  pool           = "initial"
}

resource "libvirt_domain" "server" {
  name = local.name
  running = "true"
  memory = "2048"
  #arch = "aarch64"
  #machine = "q35"
  cloudinit = libvirt_cloudinit_disk.init.id
  firmware = local.firmware
  emulator = local.emulator

  network_interface {
    bridge         = "br0"
    hostname       = "u22arm"
    wait_for_lease = true
  }

  boot_device {
    dev = [ "hd" ]
  }

  cpu {
    mode = "host-passthrough"
  }

  disk {
      volume_id = libvirt_volume.data.id
  }

  # IMPORTANT: this is a known bug on cloud images
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
  xml {
    xslt = file("changetype.xsl")
  }
}
