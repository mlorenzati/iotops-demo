output "primary_blob_connection_string" {
  description = "The primary connection string of the Storage Account."
  value       = azurerm_storage_account.storage_account.primary_blob_connection_string
}
