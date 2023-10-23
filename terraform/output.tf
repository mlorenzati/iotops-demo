output "IOT_HUB_PRIMARY_CONNECTION_STRING" {
  description = "The primary connection string of the IoT Hub."
  value       = module.iot_hub.iot_hub_primary_connection_string
  sensitive   = true
}

output "LOG_ANALYTICS_WORKSPACE_ID" {
  description = "The ID of the Log Analytics Workspace."
  value       = module.log_analytics.log_analytics_workspace_id
}

output "LOG_ANALYTICS_WORKSPACE_PRIMARY_SHARED_KEY" {
  description = "The primary shared key of the Log Analytics Workspace."
  value       = module.log_analytics.log_analytics_workspace_primary_shared_key
  sensitive   = true

}
