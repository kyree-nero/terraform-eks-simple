

module "ingress" {
  source = "./ingress"
}


module "logging" {
  count = var.logging_enabled == "true" ? 1 : 0
  source = "./logging"

  eks-cluster-name = var.eks-cluster-name
  aws-region = var.aws-region
  logging_type = var.logging_type
}

module "rbac" {
  source = "./rbac"
}

module "dashboard" {
  source = "./dashboard"
  depends_on = [ module.rbac.rbac_done ]
}