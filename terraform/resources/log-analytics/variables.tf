variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
}

variable "diagnostic_setting_name" {
  description = "The name of the Monitor Diagnostic Setting."
  type        = string
}

variable "iot_hub_id" {
  description = "The ID of the IoT Hub."
  type        = string
}

variable "tags" {
  description = "The common tags to be used in all resources."
  type        = map(string)
}
