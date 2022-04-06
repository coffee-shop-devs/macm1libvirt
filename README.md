# Mac M1 Libvirt

This module is an attempt to run Terraform against my workstation (stats below) running libvirt.


## Mac Stats

- MacBook Pro (14-inch, 2021)
- Chip: Apple M1 Pro
- Memory: 16G

## Prerequisits and Constraints

- I followed a [tutorial I found online](https://www.naut.ca/blog/2021/12/09/arm64-vm-on-macos-with-libvirt-qemu/) to run the libvirt qemu setup.
- My chipset is an aarm64 architecture (M1, see stats)
- I installed [UTM](https://github.com/utmapp/UTM) to get qemu working and jumpstart this process
  - it has the ability to output the qemu-system command it uses to launch VMs
  - this ability is key to building out the Terraform config
  - to install UTM you have to open the dmg then copy the application to your desktop rather than the application directory
  - right click to open the application so that you can get past the fact that it is a 3rd party install
  - get the dmg from their github releases, not the apple store
  - essentially, this uses the qemu-system command utm generates, converts it to libvirt, then translates that to terraform
- I installed nix using the script for macos per their [website](https://nixos.org/download.html#nix-install-macos)
