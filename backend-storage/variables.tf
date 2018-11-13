variable "resource_group" {
  description = "Enter the name of the resource group"
  default     = "terraform-rg"
}

variable "resource_group_location" {
  description = "Enter the location for the resource group"
  default     = "eastus"
}
variable "storage_acount" {
  description = "Enter the name of the storage account"
  default     = "terraformbackendprm"
}
variable "storage_container" {
  description = "Enter the name of the storage container"
  default     = "terraformstate"
}