output "iot_hub_id" {
  description = "The ID of the IoT Hub."
  value       = azurerm_iothub.iothub.id
}

output "iot_hub_primary_connection_string" {
  description = "The primary connection string of the IoT Hub."
  value       = azurerm_iothub_shared_access_policy.iothub_shared_access_policy.primary_connection_string
}
