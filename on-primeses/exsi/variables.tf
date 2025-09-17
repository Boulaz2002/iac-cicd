variable "esxi_host" {
  description = "ESXi host IP or FQDN"
  type        = string
}

variable "esxi_user" {
  description = "ESXi username (usually root)"
  type        = string
}

variable "esxi_password" {
  description = "ESXi password"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  type    = string
  default = "terraform-vm"
}

variable "vm_disk_store" {
  description = "ESXi datastore to use"
  type        = string
}

variable "vm_network" {
  description = "Portgroup/network name"
  type        = string
}

variable "vm_iso_path" {
  description = "ISO datastore path, e.g. [datastore1] iso/ubuntu.iso"
  type        = string
}
