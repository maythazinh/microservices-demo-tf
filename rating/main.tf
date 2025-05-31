# Service account for ratings
resource "kubernetes_service_account" "bookinfo_ratings" {
  metadata {
    name      = "bookinfo-ratings"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      account = "ratings"
    }
  }
  
  image_pull_secret {
    name = data.terraform_remote_state.shared_data.outputs.harbor_secret_name
  }
}

# Role binding for ratings service account
resource "kubernetes_role_binding" "ratings_binding" {
  metadata {
    name      = "ratings-binding"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
  
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = data.terraform_remote_state.shared_data.outputs.rbac_role
  }
  
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.bookinfo_ratings.metadata[0].name
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
}

# Service for ratings 
resource "kubernetes_service" "ratings" {
  metadata {
    name      = "ratings"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "ratings"
      service = "ratings"
    }
  }
  
  spec {
    selector = {
      app = "ratings"
    }
    
    port {
      name        = "http"
      port        = 9080
      target_port = 9080  
    }
  }
}

# Deployment for ratings (FIXED: multiple issues)
resource "kubernetes_deployment" "ratings_v1" {
  metadata {
    name      = "ratings-v1"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "ratings"  
      version = "v1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "ratings"
        version = "v1"
      }
    }

    template {
      metadata {
        labels = {
          app     = "ratings"
          version = "v1"
        }
      }

      spec {
        # FIXED: Use correct service account (was bookinfo_details)
        service_account_name = kubernetes_service_account.bookinfo_ratings.metadata[0].name
        
        container {
          image             = "bookinfo.may1.click/bookinfo/harbor-rating1:latest"
          name              = "ratings"
          image_pull_policy = "IfNotPresent"
          
          port {
            container_port = 9080
          }
        }        
      }
    }
  }
}