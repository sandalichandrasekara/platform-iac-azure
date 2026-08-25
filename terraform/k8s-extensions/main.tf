terraform {
  required_version = ">= 1.10.4"

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateplatform"
    container_name       = "tfstate"
    key                  = "platform-k8s-extensions.tfstate"
  }
}

data "terraform_remote_state" "cluster" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateplatform"
    container_name       = "tfstate"
    key                  = "platform-cluster.tfstate"
  }
}

data "terraform_remote_state" "k8s_base" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateplatform"
    container_name       = "tfstate"
    key                  = "platform-k8s-base.tfstate"
  }
}

locals {
  cluster = data.terraform_remote_state.cluster.outputs
}
