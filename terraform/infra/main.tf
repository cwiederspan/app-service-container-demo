terraform {
  required_version = "> 0.11.0"
}

variable "resource_group_name" { 
  default = "amp-shared-20181111-rg"
}

variable "acr_name" { 
  default = "ampimages"
}

variable "location" {
  default = "westus2"
}


resource "azurerm_resource_group" "group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"
  admin_enabled       = true
  sku                 = "Basic"
}