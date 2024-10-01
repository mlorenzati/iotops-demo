# Get the Resource Group
data "azurerm_resource_group" "resource_group" {
  name = "iotops-demo"
}

# Set common tags
locals {
  common_tags = {
    createdBy   = "felipe.santos@globant.com"
    projectName = "iot ops"
    source      = "terraform"
  }
}

module "log_analytics" {
  source = "./resources/log-analytics"

  location                     = var.location
  resource_group_name          = data.azurerm_resource_group.resource_group.name
  tags                         = local.common_tags
  diagnostic_setting_name      = var.diagnostic_setting_name
  log_analytics_workspace_name = var.log_analytics_workspace_name
  iot_hub_id                   = module.iot_hub.iot_hub_id
}

module "iot_hub" {
  source = "./resources/iot-hub"

  location                       = var.location
  resource_group_name            = data.azurerm_resource_group.resource_group.name
  tags                           = local.common_tags
  iot_hub_name                   = var.iot_hub_name
  storage_container_name         = var.storage_container_name
  primary_blob_connection_string = module.storage_account.primary_blob_connection_string
}

module "storage_account" {
  source = "./resources/storage-account"

  location               = var.location
  resource_group_name    = data.azurerm_resource_group.resource_group.name
  tags                   = local.common_tags
  storage_container_name = var.storage_container_name
}
