terraform {
  backend "remote" {
    organization = "kyree-terraform"

    workspaces {
      name = "eks-helm-dev"
    }
  }
}