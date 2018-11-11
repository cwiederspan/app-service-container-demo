terraform {
  required_version = "> 0.11.0"
}

variable "resource_group_name" { 
  default = "amp-app-20181111-rg"
}

variable "app_service_name" { 
  default = "ampsite20181111"
}

variable "location" {
  default = "westus2"
}

variable "acr_name" { 
  default = "ampimages"
}

variable "acr_password" { }

variable "image_name" { 
  # default = "microservice-api-docker-01"
}

variable "image_tag" { 
  # default = "latest"
}


resource "azurerm_resource_group" "group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.app_service_name}-plan"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  kind                = "Linux"

  properties {
    reserved = true
  }

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "${var.app_service_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  app_service_plan_id = "${azurerm_app_service_plan.plan.id}"
  #kind                = "app,linux,container"

  site_config {
    always_on         = true
    linux_fx_version  = "DOCKER|${var.acr_name}.azurecr.io/${var.image_name}:${var.image_tag}"
    #default_documents = [ "Index.html" ]
  }

  app_settings {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    DOCKER_REGISTRY_SERVER_URL          = "https://${var.acr_name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME     = "${var.acr_name}"
    DOCKER_REGISTRY_SERVER_PASSWORD     = "${var.acr_password}"
  }
}