terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "iotops-demo"
    storage_account_name = "iotopstfstate"
    container_name       = "tfstate"
    key                  = "iotops-demo-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
