variable "argocd_chart_version" {
  description = "Version of the argo-cd Helm chart."
  type        = string
  default     = "7.7.6"
}

variable "argocd_hostname" {
  description = "Hostname for the ArgoCD ingress (served through the Application Gateway / AGIC)."
  type        = string
  default     = ""
}

variable "gitops_repo_url" {
  description = "HTTPS URL of the GitOps repository ArgoCD watches. Empty skips the repo connection secret."
  type        = string
  default     = ""
}

variable "gitops_repo_username" {
  description = "Username/token owner for the GitOps repo (private repos only)."
  type        = string
  default     = ""
}

variable "gitops_repo_password" {
  description = "Personal access token / password for the GitOps repo (private repos only)."
  type        = string
  default     = ""
  sensitive   = true
}
