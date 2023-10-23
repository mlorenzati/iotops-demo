# Create a Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"

  tags = var.tags
}

# Create Diagnostic Setting for IoT Hub
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                           = var.diagnostic_setting_name
  target_resource_id             = var.iot_hub_id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
