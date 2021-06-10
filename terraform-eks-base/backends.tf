terraform {
  backend "remote" {
    organization = "kyree-terraform"

    workspaces {
      name = "eks-dev"
    }
  }
}