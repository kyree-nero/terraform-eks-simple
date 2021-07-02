

module "ingress" {
  source = "./ingress"
}


# module "logging" {
#   source = "./logging"
# }

module "rbac" {
  source = "./rbac"
}

module "dashboard" {
  source = "./dashboard"
  depends_on = [ module.rbac.rbac_done ]
}