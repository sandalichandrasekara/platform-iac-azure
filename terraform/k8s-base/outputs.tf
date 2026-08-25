output "namespace" {
  description = "Application namespace created for workloads."
  value       = kubernetes_namespace.app.metadata[0].name
}

output "service_account_name" {
  description = "Workload-identity service account name."
  value       = kubernetes_service_account.workload.metadata[0].name
}
