provider "kubernetes" {
  config_path    = "/home/vagrant/.kube/config"
  config_context = "kind-132"
}

terraform { 
  cloud { 
    
    organization = "maythazin-jp" 

    workspaces { 
      name = "reviews" 
    } 
  } 
}