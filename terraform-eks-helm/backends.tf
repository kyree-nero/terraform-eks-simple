terraform {
  backend "remote" {
    organization = "kyree-terraform"

    workspaces {
      name = "helm-dev"
    }
  }
}