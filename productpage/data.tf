data "terraform_remote_state" "shared_data" {
  backend = "remote"
  config = {
    organization= "maythazin-jp"
    workspaces = {
      name = "main-workspace"
    }
  }
}



