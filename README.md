# Azure Platform Infrastructure

Minimal **Terraform** baseline for running an application on **Azure Kubernetes
Service (AKS)**, with GitOps delivery via **ArgoCD**. Bring your own app manifests.

## What it provisions

- **Networking** — VNet with dedicated subnets (App Gateway, AKS, private endpoints) + NSG
- **Ingress** — Application Gateway with **WAF_v2** (OWASP), wired to AKS via AGIC
- **AKS** — AAD-only cluster (local accounts disabled), system + autoscaling user node pools, workload identity (OIDC)
- **Registry & secrets** — ACR and Key Vault, reachable only over private endpoints
- **Data** — Azure SQL (private, AAD-only auth)
- **Identity** — managed identity federated to a Kubernetes service account — no secrets in the cluster
- **Observability** — Log Analytics, Container Insights, metric alerts + Action Group
- **Guardrails** — Azure Policy (allowed locations, required tags)
- **Delivery** — ArgoCD for GitOps

## Layers

Applied **in order** — each keeps state in Azure Blob Storage and reads the
previous layer's outputs via `terraform_remote_state`.

| Layer | Provisions |
| --- | --- |
| `terraform/cluster` | All Azure infrastructure listed above |
| `terraform/k8s-base` | App namespace + workload-identity ServiceAccount |
| `terraform/k8s-extensions` | ArgoCD (served through the App Gateway / AGIC) |

```
terraform/{cluster,k8s-base,k8s-extensions}   the three layers
modules/                                       reusable building blocks
.github/workflows/terraform-workflow.yml       layered plan/apply CI
```

## Getting started

### 1. One-time prerequisites

```bash
# Service principal (Owner — the cluster layer creates role assignments)
az ad sp create-for-rbac --name sp-terraform-platform --role Owner \
  --scopes /subscriptions/<subscription-id>

# Remote-state backend (matches the backend blocks: rg-tfstate / sttfstateplatform / tfstate)
az group create -n rg-tfstate -l eastus
az storage account create -n sttfstateplatform -g rg-tfstate -l eastus \
  --sku Standard_LRS --min-tls-version TLS1_2 --allow-blob-public-access false
az storage container create -n tfstate --account-name sttfstateplatform --auth-mode login

# Terraform reads credentials from the environment
export ARM_CLIENT_ID=... ARM_CLIENT_SECRET=... ARM_TENANT_ID=... ARM_SUBSCRIPTION_ID=...
```

### 2. Deploy

```bash
cd terraform/cluster
cp terraform.tfvars.example terraform.tfvars   # edit values
terraform init && terraform apply

cd ../k8s-base        && terraform init && terraform apply
cd ../k8s-extensions  && terraform init && terraform apply
```

CI (`.github/workflows/terraform-workflow.yml`) runs the same layers in order:
plan on pull requests, apply on push to `main`.

### 3. Cluster access

Local accounts are disabled, so use your own Azure identity:

```bash
az aks get-credentials -g <resource-group> -n <cluster-name>
kubelogin convert-kubeconfig -l azurecli
```

## License

See [LICENSE](LICENSE).
