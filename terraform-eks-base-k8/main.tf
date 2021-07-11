
module "rbac" {
  source = "./rbac"
}

module "logging" {
  count = var.logging_enabled == "true" ? 1 : 0
  source = "./logging"

  eks-cluster-name = var.eks-cluster-name
  aws-region = var.aws-region
  logging_type = var.logging_type
}

module "ingress" {
  source = "./ingress"
}

module "dashboard" {
  count = var.k8_dash_enabled == "true" ? 1 : 0
  source = "./dashboard"
  depends_on = [ module.rbac.rbac_done ]
}

module "monitoring" {
  count = var.monitoring_enabled == "true" ? 1 : 0
  source = "./monitoring"
  monitoring_type = var.monitoring_type
}
