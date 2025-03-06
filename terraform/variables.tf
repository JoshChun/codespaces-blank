variable "rg_name" {
    description = "The name of the Azure resource group"
    type = string
}

variable "rg_location" {
    description = "The location for the resource group"
    type = string
    default = "australiaeast"
}

variable "vm_name" {
    description = "Virtual machine name"
    type = string
}

variable "admin_username" {
    description = "Admin username for virtual machine"
    type = string
}

variable "public_ssh_key" {
    description = "SSH public key"
    type = string
}