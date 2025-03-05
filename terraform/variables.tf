variable "rg_name" {
    description = "The name of the Azure resource group"
    type = string
}

variable "rg_location" {
    description = "The location for the resource group"
    type = string
    default = "australiaeast"
}