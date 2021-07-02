# resource "kubernetes_namespace" "dashboard" {
#   metadata {
#     name = "kubernetes-dashboard"
#   }
# }


# resource "helm_release" "dashboard" {
#   name       = "kubernetes-dashboard"
#   repository = "https://kubernetes.github.io/dashboard/"
#   chart      = "kubernetes-dashboard"
#   version =  "2.3.0"
#   namespace = "kubernetes-dashboard"

#   depends_on = [kubernetes_namespace.dashboard]
# }

resource "helm_release" "dashboard" {
  name       = "dashboard"
  chart      = "./dashboard/helm-charts/dashboard"
}