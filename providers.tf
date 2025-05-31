terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}

provider "kubernetes" {
  config_path    = "/home/vagrant/.kube/config"
  config_context = "kind-132"
}



##terraform token

terraform { 
  cloud { 
    
    organization = "maythazin-jp" 

    workspaces { 
      name = "main-workspace" 
    } 
  } 
}