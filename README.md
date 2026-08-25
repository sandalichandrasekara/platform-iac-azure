# Azure Platform Infrastructure

Cloud-native **Terraform** platform on **Azure Kubernetes Service (AKS)** with
GitOps-style delivery (ArgoCD), built to follow the
[Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)
across reliability, security, cost, operational excellence, and performance.

> **Approach:** the platform baseline — an AKS cluster, secure ingress, identity
> without secrets, private data access, observability, guardrails, and ArgoCD for
> GitOps delivery. Bring your own application manifests.

---

## Architecture at a glance

```
                          Internet
                             │
                    ┌────────▼─────────┐
                    │  Application      │   Public IP
                    │  Gateway + WAF_v2 │   (OWASP ruleset)
                    └────────┬─────────┘
                             │  (AGIC ingress)
        ┌────────────────────▼───────────────────────┐
        │                 VNet (Azure CNI)            │
        │  ┌──────────────┐        ┌───────────────┐  │
        │  │ snet-appgw    │       │ snet-aks       │  │
        │  └──────────────┘        │  ┌──────────┐  │  │
        │                          │  │ System   │  │  │
        │                          │  │ nodepool │  │  │
        │                          │  ├──────────┤  │  │
        │                          │  │ User     │  │  │
        │                          │  │ nodepool │  │  │
        │                          │  │  + HPA   │  │  │
        │                          │  └──────────┘  │  │
        │                          └───────┬────────┘  │
        │   ┌──────────────────────────────▼────────┐  │
        │   │ snet-private-endpoints                 │  │
        │   │  Key Vault · ACR · Azure SQL (private) │  │
        │   └────────────────────────────────────────┘  │
        └──────────────────────────────────────────────┘

 Identity:  Managed Identity + Workload Identity (OIDC) - no secrets in cluster
 Observ.:   Azure Monitor · Log Analytics · Container Insights · Action Groups
 Guardrails: Azure Policy (compliance-as-code)
```

## Repository layout

```
terraform/
  cluster/          Azure foundation: RG, networking, ACR, Key Vault, App Gateway+WAF,
                    AKS (AAD-only, workload identity, AGIC), managed identity, SQL, policy
  k8s-base/         app namespace + workload-identity ServiceAccount
  k8s-extensions/   ArgoCD (GitOps), served via AGIC
modules/            Reusable Terraform modules consumed by the cluster layer
.github/workflows/  terraform-workflow.yml (layered plan/apply)
```

The three Terraform layers are applied **in order** (`cluster → k8s-base →
k8s-extensions`) and chained via `terraform_remote_state`. State is stored in
Azure Blob Storage, with the backend hardcoded per layer.

## Getting started

```bash
# 1. One-time bootstrap: a service principal (Owner, for role assignments) and
#    the Azure Blob backend the layers expect (rg-tfstate / sttfstateplatform / tfstate).
az ad sp create-for-rbac --name sp-terraform-platform --role Owner \
  --scopes /subscriptions/<subscription-id>
az group create -n rg-tfstate -l eastus
az storage account create -n sttfstateplatform -g rg-tfstate -l eastus \
  --sku Standard_LRS --min-tls-version TLS1_2 --allow-blob-public-access false
az storage container create -n tfstate --account-name sttfstateplatform --auth-mode login

# 2. Apply each layer in order
cd terraform/cluster && cp terraform.tfvars.example terraform.tfvars  # then edit
terraform init && terraform apply
cd ../k8s-base        && terraform init && terraform apply
cd ../k8s-extensions  && terraform init && terraform apply
```

## License

See [LICENSE](LICENSE).
