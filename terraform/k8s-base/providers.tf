terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.35.1"
    }
  }
}

# AKS has local accounts disabled (AAD + Azure RBAC only), so the provider
# authenticates via kubelogin using the Terraform service principal.
# The GitHub Actions workflow exports AAD_SERVICE_PRINCIPAL_CLIENT_ID,
# AAD_SERVICE_PRINCIPAL_CLIENT_SECRET and AZURE_TENANT_ID for this.
provider "kubernetes" {
  host                   = local.cluster.kube_config_host
  cluster_ca_certificate = base64decode(local.cluster.kube_config_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login", "spn",
      "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630", # AKS AAD server app ID
      "--environment", "AzurePublicCloud",
    ]
  }
}
