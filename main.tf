terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.92.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "terraform_blobstore"
    storage_account_name  = "terraformstoragesbc"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "tf_test" {
  name      = "tfmainrg"
  location  = "East US"
  
}

resource "azurerm_container_group" "tfcg_test" {
    name                = "weatherapi"
    location            = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type     = "public"
    dns_name_label      = "sbcookwapi"
    os_type             = "Linux"

    container {
      name              = "weatherapi"
      image             = "sbcook/weatherapi"
        cpu             = "1"
        memory          = "1"

        ports {
          port          = 80
          protocol      = "TCP"
        }
    }
}