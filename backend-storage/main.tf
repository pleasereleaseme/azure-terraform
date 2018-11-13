resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group}"
  location = "${var.resource_group_location}"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage_account}"
  resource_group_name      = "${azurerm_resource_group.resource_group.name}"
  location                 = "${var.resource_group_location}"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  account_kind             = "StorageV2"
  access_tier              = "hot"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "${var.storage_container}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
  container_access_type = "private"
}