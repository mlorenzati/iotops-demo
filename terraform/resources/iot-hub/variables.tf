variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
}

variable "iot_hub_name" {
  description = "The name of the IoT Hub."
  type        = string
}

variable "tags" {
  description = "The common tags to be used in all resources."
  type        = map(string)
}

variable "storage_container_name" {
  description = "The name of the Storage Container."
  type        = string
}

variable "primary_blob_connection_string" {
  description = "The primary connection string of the Storage Account."
  type        = string
}
