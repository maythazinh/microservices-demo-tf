# Service account for details
resource "kubernetes_service_account" "bookinfo_details" {
  metadata {
    name      = "bookinfo-details"  
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      account = "details"  
    }
  }
  
  image_pull_secret {
    name = data.terraform_remote_state.shared_data.outputs.harbor_secret_name
  }
}

# Role binding for details service account
resource "kubernetes_role_binding" "details_binding" {
  metadata {
    name      = "details-binding"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
  
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = data.terraform_remote_state.shared_data.outputs.rbac_role
      }
  
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.bookinfo_details.metadata[0].name 
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
}

# Service for details
resource "kubernetes_service" "details" {
  metadata {
    name      = "details"  
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "details"
      service = "details"
    }
  }
  
  spec {
    selector = {
      app = "details"
    }
    
    port {
      name        = "http"
      port        = 9080
      target_port = 9080  
    }
  }
}

# Deployment for details
resource "kubernetes_deployment" "details_v1" {
  metadata {
    name      = "details-v1"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "details"
      version = "v1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "details"
        version = "v1"
      }
    }

    template {
      metadata {
        labels = {
          app     = "details"
          version = "v1"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.bookinfo_details.metadata[0].name
        
        container {
          image             = "bookinfo.may1.click/bookinfo/harbor-details:latest"
          name              = "details"
          image_pull_policy = "IfNotPresent"
          
          port {
            container_port = 9080
          }
        }        
      }
    }
  }
}