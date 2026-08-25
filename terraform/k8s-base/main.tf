terraform {
  required_version = ">= 1.10.4"

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateplatform"
    container_name       = "tfstate"
    key                  = "platform-k8s-base.tfstate"
  }
}

# Outputs from the cluster layer (RG, AKS endpoint, workload identity).
data "terraform_remote_state" "cluster" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateplatform"
    container_name       = "tfstate"
    key                  = "platform-cluster.tfstate"
  }
}

locals {
  cluster = data.terraform_remote_state.cluster.outputs
}

# Application namespace: the landing zone for workloads deployed via GitOps.
# Created here so the workload-identity service account below can be federated.
resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
    labels = {
      name = "app"
    }
  }
}

# Workload-identity service account. The federated credential for this
# namespace/name is created in the cluster layer (identity module).
resource "kubernetes_service_account" "workload" {
  metadata {
    name      = "workload-sa"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "azure.workload.identity/client-id" = local.cluster.workload_identity_client_id
    }
    labels = {
      "azure.workload.identity/use" = "true"
    }
  }
}
