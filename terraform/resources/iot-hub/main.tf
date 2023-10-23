# Create an IoT Hub
resource "azurerm_iothub" "iothub" {
  name                = var.iot_hub_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "F1"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = var.primary_blob_connection_string
    name                       = "iotops-endpoint"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = var.storage_container_name
    encoding                   = "JSON"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  route {
    name           = "iotops-route"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["iotops-endpoint"]
    enabled        = true
  }

  tags = var.tags
}

# Create an IoT Hub Shared Access Policy
resource "azurerm_iothub_shared_access_policy" "iothub_shared_access_policy" {
  name                = "${var.iot_hub_name}-policy"
  resource_group_name = var.resource_group_name
  iothub_name         = azurerm_iothub.iothub.name

  registry_read   = true
  registry_write  = true
  service_connect = true
  device_connect  = true
}
