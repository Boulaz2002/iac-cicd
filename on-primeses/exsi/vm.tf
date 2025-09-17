resource "esxi_guest" "vm" {
  guest_name       = var.vm_name
  disk_store       = var.vm_disk_store
  network_interfaces = [var.vm_network]
  boot_firmware    = "bios"

  guestos         = "ubuntu-64"
  memsize         = 2048
  numvcpus        = 2

  disks {
    size = 20
  }

  cdrom {
    datastore_iso_file = var.vm_iso_path
  }
}
