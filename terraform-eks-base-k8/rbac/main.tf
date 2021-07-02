resource "helm_release" "rbac" {
  name       = "rbac-admin-chart"
  chart      = "./rbac/helm-charts/rbac-admin"
}