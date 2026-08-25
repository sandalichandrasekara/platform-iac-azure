resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.argocd_chart_version

  values = [yamlencode({
    configs = {
      params = {
        # TLS terminates at the Application Gateway; run the server in HTTP mode.
        "server.insecure" = true
      }
    }
    server = {
      ingress = {
        enabled          = var.argocd_hostname != ""
        ingressClassName = "azure-application-gateway"
        annotations = {
          "appgw.ingress.kubernetes.io/backend-protocol" = "http"
        }
        hostname = var.argocd_hostname
      }
    }
  })]

  depends_on = [kubernetes_namespace.argocd]
}

# Repository connection for the GitOps repo ArgoCD reconciles from.
resource "kubernetes_secret" "gitops_repo" {
  count = var.gitops_repo_url == "" ? 0 : 1

  metadata {
    name      = "argocd-gitops-repo"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type     = "git"
    url      = var.gitops_repo_url
    username = var.gitops_repo_username
    password = var.gitops_repo_password
  }

  depends_on = [helm_release.argocd]
}
