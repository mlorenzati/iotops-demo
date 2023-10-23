variable "iot_hub_name" {
  description = "The name of the IoT Hub."
  type        = string
  default     = "iotops-hub"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
  default     = "iotops-log-analytics"
}

variable "diagnostic_setting_name" {
  description = "The name of the Monitor Diagnostic Setting."
  type        = string
  default     = "iotops-diagnostic-setting"
}

variable "storage_account_name" {
  description = "The name of the Storage Account."
  type        = string
  default     = "iotopsstorageaccount"
}

variable "storage_container_name" {
  description = "The name of the Storage Container."
  type        = string
  default     = "iotops-container"
}
