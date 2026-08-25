# Azure Platform Infrastructure

Cloud-native **Terraform** platform that runs a containerized application on
**Azure Kubernetes Service (AKS)** with GitOps-style delivery, built to follow
the [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)
across reliability, security, cost, operational excellence, and performance.

> **Approach:** This is a full platform: an AKS cluster,
> secure ingress, identity without secrets, private data access, observability,
> guardrails, and a CI/CD pipeline that builds, scans, pushes, and deploys.

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
kustomize/base/web/ App manifests: common/ base + dev|test|stage|prod-us overlays
scripts/            One-time bootstrap (Terraform SP, state storage account)
.github/workflows/  terraform-workflow.yml (layered apply) · app-build.yml (build/scan/push)
```

The three Terraform layers are applied **in order** (`cluster → k8s-base →
k8s-extensions`) and chained via `terraform_remote_state`. State is stored in
Azure Blob Storage, with the backend hardcoded per layer.

## Getting started

```bash
# 1. One-time bootstrap (see scripts/README.md)
scripts/terraform-sp/create-terraform-sp.sh <subscription-id>
scripts/terraform-storage/create-storage-account.sh rg-tfstate sttfstateplatform eastus

# 2. Apply each layer in order
cd terraform/cluster && cp terraform.tfvars.example terraform.tfvars  # then edit
terraform init && terraform apply
cd ../k8s-base        && terraform init && terraform apply
cd ../k8s-extensions  && terraform init && terraform apply
```

## License

See [LICENSE](LICENSE).
