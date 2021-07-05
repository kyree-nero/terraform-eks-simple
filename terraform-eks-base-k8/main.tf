

module "ingress" {
  source = "./ingress"
}


module "logging" {
  source = "./logging"

  eks-cluster-name = var.eks-cluster-name
  aws-region = var.aws-region
}

module "rbac" {
  source = "./rbac"
}

module "dashboard" {
  source = "./dashboard"
  depends_on = [ module.rbac.rbac_done ]
}