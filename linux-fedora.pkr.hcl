source "qemu" "linux-fedora" {
  # General
  vm_name                   = "${var.name}"
  format                    = "raw"
  accelerator               = "kvm"
  # ISO Source
  iso_url                   = "${var.qemu_iso_url}"
  iso_checksum              = "${var.qemu_iso_checksum}"
  # Boot Command
  boot_command              = ["<up><tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.os}.ks<enter><wait>"]
  boot_wait                 = "10s"
  http_directory            = "ks"
  ssh_username              = "root"
  ssh_private_key_file      = "~/.ssh/id_ed25519"
  # Resources
  output_directory          = "build"
  net_device                = "virtio-net"
  net_bridge                = "virbr0"
  disk_interface            = "virtio"
  disk_size                 = "${var.qemu_disk_size}"
  memory                    = "${var.qemu_memory}"
  cores                     = "${var.qemu_cpus}"
  qemuargs                = [
    [
      "-cpu",
      "host,x2apic=on,tsc-deadline=on,hypervisor=on,tsc-adjust=on,erms=on,vaes=on,vpclmulqdq=on,",
      "spec-ctrl=on,stibp=on,arch-capabilities=on,ssbd=on,xsaves=on,cmp-legacy=on,ibrs=on,",
      "amd-ssbd=on,virt-ssbd=on,rdctl-no=on,skip-l1dfl-vmentry=on,mds-no=on,pschange-mc-no=on"
    ]
  ]
}


build {
  sources = ["source.qemu.linux-fedora"]

  provisioner "shell" {
    inline = ["subscription-manager register --org ${var.rhsm_org_id} --activationkey ${var.rhsm_key}"]
  }

  provisioner "shell" {
    inline = var.post_prov_commands
  }
}