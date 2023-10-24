terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.77.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "iotops-demo"
    storage_account_name = "iotopstfstate"
    container_name       = "tfstate"
    key                  = "iotops-terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}
