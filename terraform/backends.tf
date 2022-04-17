# --- root/backends.tf ---

terraform {
  backend "remote" {
    organization = "trobsec"

    workspaces {
      name = "terraform-nginx-host"
    }
  }
}