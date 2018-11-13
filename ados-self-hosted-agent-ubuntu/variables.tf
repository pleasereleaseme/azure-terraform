# Variables that should be tracked and changed via version control
variable "node_count" {
  description = "Enter the number of nodes to create"
  default     = 2
}

variable "base_name" {
  description = "Enter a base name for the resources that will be created"
  default     = "ados-self-hosted-agent-ubuntu"
}

variable "resource_group_location" {
  description = "Enter the location for the resource group"
  default     = "eastus"
}

variable "vm_size" {
  description = "Enter a name for the VM size"
  default     = "Standard_DS1_v2"
}

variable "ubuntu_sdk" {
  description = "Enter a name for the Ubuntu SDK"
  default     = "18.04-LTS"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = "map"

  default = {
    label = "ados-self-hosted-agent-ubuntu"
  }
}

# Variables that can or should be supplied via terraform.tfvars or a CI/CD pipeline
variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}

variable "environment" {
  description = "Enter a name for the environment, eg dev or prd"
}

variable "ssh_key_data" {
  description = "Enter the SSH public key to use"
}

variable "admin_username" {
  description = "Enter an admin username for the virtual machine OS"
}
