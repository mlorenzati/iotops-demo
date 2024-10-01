# Random String for Storage Account Name
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
locals {
  storage_account_name = "iotopsstorageaccount${random_string.random.result}"
}
# Create a Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Create Source Container
resource "azurerm_storage_container" "container_data" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
