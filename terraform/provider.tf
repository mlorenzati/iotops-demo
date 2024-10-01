terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "iotops-demo"
    storage_account_name = "iotopstfstate2"
    container_name       = "tfstate"
    key                  = "iotops-demo-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}
