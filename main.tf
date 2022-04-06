# NOTE: LIBVIRT_DEFAULT_URI needs to be set, probably to qemu:///session (validate with 'virsh uri' command)
provider "libvirt" {
  uri = "qemu+unix:///session?socket=/opt/homebrew/var/run/libvirt/libvirt-sock"
}

resource "libvirt_domain" "default" {
  name = "U20ARM"
  description = "Ubuntu 20.04 LTS ARM version"
  running = "true"
  vcpu = "2"
  memory = "2048"
  arch = "aarch64"
  machine = "virt,highmem=off"
  cloudinit = ""
  boot_device {
    dev = ["hd"]
  }
  cpu {
    mode = "host-passthrough"
  }
  disk {
      volume_id = ""
  }
  network_interface {
      network_id = ""
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
}
