# usage: qemu-system-aarch64 [options] [disk_image]
#
# -L -> set the directory for the BIOS, VGA BIOS and keymaps
#
# https://wiki.qemu.org/Documentation/QMP
# Start QMP on a TCP socket, so that telnet can be used
# -qmp tcp:localhost:4444,server,nowait
#
# https://manpages.debian.org/testing/qemu-system-common/qemu-system.1.en.html
# If there is more than one accelerator specified, the next one is used if the previous one fails to initialize.
#
# device virtio-net-pci -> Nic associated with -netdev options

qemu-system-aarch64 \
  # system info
  -name U20ARM \
  -uuid BB2BF207-D5CA-46D0-BD71-DA133B4FF06D \
  -machine virt,highmem=off
  -accel hvf \
  -accel tcg,tb-size=1536 \
  -cpu host \
  -smp cpus=2,sockets=1,cores=2,threads=1 \
  -m 2G \
  -boot menu=on \
  -nodefaults \
  -vga none \
  -rtc base=localtime \
  \
  # networking
  -device virtio-net-pci,mac=0A:7F:25:C0:06:6D,netdev=net0 \
  -netdev vmnet-macos,mode=shared,id=net0 \
  \
  # console
  -qmp tcp:127.0.0.1:4444,server,nowait \
  -spice "unix=on,addr=/Users/mtrachier/Library/Group Containers/WDNLXAD4W8.com.utmapp.UTM/BB2BF207-D5CA-46D0-BD71-DA133B4FF06D.spice,disable-ticketing=on,image-compression=off,playback-compression=off,streaming-video=off,gl=off" \
  -device virtio-serial
  -device virtserialport,chardev=vdagent,name=com.redhat.spice.0
  -chardev spicevmc,id=vdagent,debug=0,name=vdagent
  -device virtserialport,chardev=charchannel1,id=channel1,name=org.spice-space.webdav.0
  -chardev spiceport,name=org.spice-space.webdav.0,id=charchannel1
  \
  # bios
  -L /Users/mtrachier/Desktop/UTM.app/Contents/Resources/qemu \
  -drive if=pflash,format=raw,unit=0,file=/Users/mtrachier/Desktop/UTM.app/Contents/Resources/qemu/edk2-aarch64-code.fd,readonly=on \
  \
  # boot disks and installer image
  -drive if=none,media=cdrom,id=cdrom0 \
  -device usb-storage,drive=cdrom0,removable=true,bootindex=0,bus=usb-bus.0 \
  -device virtio-blk-pci,drive=drive0,bootindex=1 \
  -drive if=none,media=disk,id=drive0,file=/Users/mtrachier/Library/Containers/com.utmapp.UTM/Data/Documents/U20ARM.utm/Images/data.qcow2,cache=writethrough \
  \
  -device virtio-ramfb \
  -device intel-hda \
  -device virtio-rng-pci \
  \
  -device nec-usb-xhci,id=usb-bus \
  -device usb-mouse,bus=usb-bus.0 \
  -device usb-kbd,bus=usb-bus.0 \
  \
  \
  -drive if=pflash,unit=1,file=/Users/mtrachier/Library/Containers/com.utmapp.UTM/Data/Documents/U20ARM.utm/Images/efi_vars.fd \
  -device hda-duplex
  -device usb-tablet,bus=usb-bus.0

  -device ich9-usb-ehci1,id=usb-controller-0
  -device ich9-usb-uhci1,masterbus=usb-controller-0.0,firstport=0,multifunction=on
  -device ich9-usb-uhci2,masterbus=usb-controller-0.0,firstport=2,multifunction=on
  -device ich9-usb-uhci3,masterbus=usb-controller-0.0,firstport=4,multifunction=on

  -chardev spicevmc,name=usbredir,id=usbredirchardev0
    -device usb-redir,chardev=usbredirchardev0,id=usbredirdev0,bus=usb-controller-0.0

  -chardev spicevmc,name=usbredir,id=usbredirchardev1
    -device usb-redir,chardev=usbredirchardev1,id=usbredirdev1,bus=usb-controller-0.0

  -chardev spicevmc,name=usbredir,id=usbredirchardev2
    -device usb-redir,chardev=usbredirchardev2,id=usbredirdev2,bus=usb-controller-0.0
