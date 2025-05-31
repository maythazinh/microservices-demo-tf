terraform { 
  cloud { 
    
    organization = "maythazin-jp" 

    workspaces { 
      name = "main-workspace" 
    } 
  } 
}