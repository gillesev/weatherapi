terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.57.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "tf-storage"
    storage_account_name = "getfstorage"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "tf_rg" {
  name = "tf-main-rg"
  location = "eastus2"
}

resource "azurerm_container_group" "tf-container-group" {
  name = "weatherapi-container-group"
  location = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name
  
  ip_address_type = "public"
  dns_name_label = "gillesevdomain"
  os_type = "Linux"

  container {
    name = "weatherapi"
    image = "gillesev/weatherapi"
    cpu = 1
    memory = 1
    ports {
      port = 80
      protocol = "TCP"
    }
  }
}