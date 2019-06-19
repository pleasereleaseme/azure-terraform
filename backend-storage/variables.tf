variable "resource_group" {
  description = "Enter the name of the resource group"
  default     = "terraform-rg"
}

variable "resource_group_location" {
  description = "Enter the location for the resource group"
  default     = "eastus"
}
variable "storage_account" {
  description = "Enter the name of the storage account"
  default     = "terraformbackendprm"
}
variable "storage_container" {
  description = "Enter the name of the storage container"
  default     = "terraformstate"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = "map"

  default = {
    CreatedBy =  "Terraform"
  }
}