//namespace
resource "kubernetes_namespace" "task8" {
  metadata {
    name = "task8"
  }
}

//secrets
resource "kubernetes_secret" "harbor_creds" {
  metadata {
    name      = "harbor-creds"
    namespace = kubernetes_namespace.task8.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

## use which continer register u wanna use, here using harbor
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "xxxxxxxx" = {   # ← This is your Harbor registry URL
    username = "admin"
          username = "admin"
          password = "xxxxx"  # Replace with actual password
          auth     = base64encode("admin:xxxxx")  # Replace with actual password
        }
      }
    })
  }
}


//RBAC Role for all microservices
resource "kubernetes_role" "bookinfo_microservices" {
  metadata {
    namespace = kubernetes_namespace.task8.metadata[0].name
    name      = "bookinfo-microservices"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log"]
    verbs      = ["get", "list", "watch"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["services", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list"]
  }
}


