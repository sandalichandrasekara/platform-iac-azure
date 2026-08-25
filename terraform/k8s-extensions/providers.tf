terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.35.1"
    }
  }
}

# AAD-only cluster (local accounts disabled): authenticate the kubernetes/helm
# providers via kubelogin. See terraform/k8s-base/providers.tf for the env vars.
locals {
  kubelogin_args = [
    "get-token",
    "--login", "spn",
    "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630", # AKS AAD server app ID
    "--environment", "AzurePublicCloud",
  ]
}

provider "kubernetes" {
  host                   = local.cluster.kube_config_host
  cluster_ca_certificate = base64decode(local.cluster.kube_config_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args        = local.kubelogin_args
  }
}

provider "helm" {
  kubernetes {
    host                   = local.cluster.kube_config_host
    cluster_ca_certificate = base64decode(local.cluster.kube_config_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args        = local.kubelogin_args
    }
  }
}
