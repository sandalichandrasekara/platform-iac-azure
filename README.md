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

## License

See [LICENSE](LICENSE).
