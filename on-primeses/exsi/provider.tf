terraform {
  required_version = ">= 0.13"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
      #
      # For more information, see the provider source documentation:
      # https://github.com/josenk/terraform-provider-esxi
      # https://registry.terraform.io/providers/josenk/esxi
    }
  }
}

provider "esxi" {
  esxi_hostname = var.esxi_host
  esxi_hostport = 22
  esxi_hostssl  = "443"
  esxi_username = var.esxi_user
  esxi_password = var.esxi_password
}
