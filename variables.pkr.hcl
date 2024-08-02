variable "name" {
  type    = string
  default = "rhel-9.4"
  description = "The name of the virtual machine"
}

variable "os" {
  type    = string
  default = "${env("OS")}"
  description = "OS variable used in kickstart inst.ks"
}

variable "qemu_iso_url" {
  type    = string
  default = "http://path-to-your-rhel.iso"
  description = "The URL for the ISO file"
}

variable "qemu_iso_checksum" {
  type    = string
  default = "your-checksum-value"
  description = "The checksum of the ISO file"
}

variable "qemu_disk_size" {
  type    = string
  default = "32G"
  description = "The disk size for the virtual machine in MB"
}

variable "qemu_memory" {
  type    = number
  default = 2048
  description = "The amount of memory for the virtual machine in MB"
}

variable "qemu_cpus" {
  type    = number
  default = 2
  description = "The number of CPUs for the virtual machine"
}

variable "rhsm_org_id" {
  type    = string
  default = "${env("RHSM_ORG_ID")}"
  description = "The Red Hat Subscription Manager organization ID"
}

variable "rhsm_key" {
  type    = string
  default = "${env("RHSM_KEY")}"
  description = "The Red Hat Subscription Manager activation key"
}

variable "post_prov_commands" {
  type    = list(string)
  default = ["uname -a","date"]
}