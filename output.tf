//output
output "harbor_secret_name" {
  description = "Name of the Harbor registry secret"
  value     =kubernetes_secret.harbor_creds.metadata[0].name
}

output "rbac_role" {
  description = "RBAC role created for all microservices"
  value = kubernetes_role.bookinfo_microservices.metadata[0].name
}

output "namespace" {
  description = "the name of the namespace"
  value = kubernetes_namespace.task8.metadata[0].name
  
}

output "namespace_id" {
  description = "Full namespace resource ID"
  value       = kubernetes_namespace.task8.id
}

output "secret_id" {
  description = "Full secret resource ID"
  value       = kubernetes_secret.harbor_creds.id
}

output "role_id" {
  description = "Full role resource ID"
  value       = kubernetes_role.bookinfo_microservices.id
}