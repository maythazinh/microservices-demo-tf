# Service account for reviews
resource "kubernetes_service_account" "bookinfo_reviews" {
  metadata {
    name      = "bookinfo-reviews"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      account = "reviews"
    }
  }
  
  image_pull_secret {
    name = data.terraform_remote_state.shared_data.outputs.harbor_secret_name
  }
}

# Role binding for reviews service account
resource "kubernetes_role_binding" "reviews_binding" {
  metadata {
    name      = "reviews-binding"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
  
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = data.terraform_remote_state.shared_data.outputs.rbac_role
  }
  
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.bookinfo_reviews.metadata[0].name
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
}

# Service for reviews (FIXED: was duplicated and named "details")
resource "kubernetes_service" "reviews" {
  metadata {
    name      = "reviews"  # Fixed: was "details"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "reviews"
      service = "reviews"
    }
  }
  
  spec {
    selector = {
      app = "reviews"
    }
    
    port {
      name        = "http"
      port        = 9080
      target_port = 9080  
    }
  }
}

# Deployment for reviews-v1 
resource "kubernetes_deployment" "reviews_v1" {
  metadata {
    name      = "reviews-v1"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "reviews"
      version = "v1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "reviews"
        version = "v1"
      }
    }

    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v1"
        }
      }

      spec {
        # FIXED: Use correct service account (was bookinfo_details)
        service_account_name = kubernetes_service_account.bookinfo_reviews.metadata[0].name
        
        container {
          image             = "bookinfo.may1.click/bookinfo/harbor-review1:latest"
          name              = "reviews"
          image_pull_policy = "IfNotPresent"
          
          port {
            container_port = 9080
          }
          
          env {
            name  = "LOG_DIR"
            value = "/tmp/logs"
          }
          
          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
          
          volume_mount {
            name       = "wlp-output"
            mount_path = "/opt/ibm/wlp/output"
          }
        }
        
        # FIXED: Syntax for emptyDir
        volume {
          name = "wlp-output"
          empty_dir {}
        }
        
        volume {
          name = "tmp"
          empty_dir {}
        }
      }       
    }
  }
}

# Reviews-v2 deployment
resource "kubernetes_deployment" "reviews_v2" {
  metadata {
    name      = "reviews-v2"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "reviews"
      version = "v2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "reviews"
        version = "v2"
      }
    }

    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v2"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.bookinfo_reviews.metadata[0].name
        
        container {
          image             = "bookinfo.may1.click/bookinfo/harbor-review2:latest"
          name              = "reviews"
          image_pull_policy = "IfNotPresent"
          
          port {
            container_port = 9080
          }
          
          env {
            name  = "LOG_DIR"
            value = "/tmp/logs"
          }
          
          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
          
          volume_mount {
            name       = "wlp-output"
            mount_path = "/opt/ibm/wlp/output"
          }
        }
        
        volume {
          name = "wlp-output"
          empty_dir {}
        }
        
        volume {
          name = "tmp"
          empty_dir {}
        }
      }       
    }
  }
}

# Reviews-v3 deployment
resource "kubernetes_deployment" "reviews_v3" {
  metadata {
    name      = "reviews-v3"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "reviews"
      version = "v3"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "reviews"
        version = "v3"
      }
    }

    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v3"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.bookinfo_reviews.metadata[0].name
        
        container {
          image             = "bookinfo.may1.click/bookinfo/harbor-review3:latest"
          name              = "reviews"
          image_pull_policy = "IfNotPresent"
          
          port {
            container_port = 9080
          }
          
          env {
            name  = "LOG_DIR"
            value = "/tmp/logs"
          }
          
          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
          
          volume_mount {
            name       = "wlp-output"
            mount_path = "/opt/ibm/wlp/output"
          }
        }
        
        volume {
          name = "wlp-output"
          empty_dir {}
        }
        
        volume {
          name = "tmp"
          empty_dir {}
        }
      }       
    }
  }
}