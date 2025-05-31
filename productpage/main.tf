
# Service account for productpage
resource "kubernetes_service_account" "bookinfo_productpage" {
  metadata {
    name      = "bookinfo-productpage"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      account = "productpage"
      app     = "bookinfo"
    }
  }
  
  image_pull_secret {
    name = data.terraform_remote_state.shared_data.outputs.harbor_secret_name
  }
}

# Role binding for productpage service account
resource "kubernetes_role_binding" "productpage_binding" {
  metadata {
    name      = "productpage-binding"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
  
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = data.terraform_remote_state.shared_data.outputs.rbac_role
  }
  
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.bookinfo_productpage.metadata[0].name
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
  }
}

# Service for productpage (FIXED: resource name was "details")
resource "kubernetes_service" "productpage" {
  metadata {
    name      = "productpage"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "productpage"
      service = "productpage"
    }
  }
  
  spec {
    selector = {
      app = "productpage"
    }
    
    port {
      name        = "http"
      port        = 9080
      target_port = 9080  
    }
  }
}

# Deployment for productpage
resource "kubernetes_deployment" "productpage" {
  metadata {
    name      = "productpage-v1"
    namespace = data.terraform_remote_state.shared_data.outputs.namespace
    labels = {
      app     = "productpage"
      version = "v1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "productpage"
        version = "v1"
      }
    }

    template {
      metadata {
        # FIXED: Annotations must be strings
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "9080"
          "prometheus.io/path"   = "/metrics"
        }
        labels = {
          app     = "productpage"
          version = "v1"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.bookinfo_productpage.metadata[0].name
        
        container {
          image             = "bookinfo.may1.click/bookinfo/harbor-productpage:latest"
          name              = "productpage"
          image_pull_policy = "IfNotPresent"
          
          port {
            container_port = 9080
          }
          
          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
        }
        
       
        volume {
          name = "tmp"
          empty_dir {}  
      }        
    }
  }
}
}