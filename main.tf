#  Provider and Terraform Settings
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.46"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.rgname
  location = var.location 
}

# Virtual Network and Subnet
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aksVNet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aksSubnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.10.0.0/24"]
}

# AKS Cluster

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks-cluster
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaksdns"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }
}


# Azure Container Registry

resource "azurerm_container_registry" "acr" {
  name                     = var.acr
  resource_group_name      = azurerm_resource_group.aks_rg.name
  location                 = azurerm_resource_group.aks_rg.location
  sku                      = "Basic"
  admin_enabled            = true
}
