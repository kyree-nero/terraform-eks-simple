# resource "kubectl_manifest" "kub_app_deployment" {
#     yaml_body = file("${path.root}/app-deployment.yaml")
# }

resource "helm_release" "simple_app" {
  name       = "simple-chart"
  #chart      = "./helm-charts/simple-helm"
  #chart      = "./helm-charts/simple-helm-with-service"
  #chart      = "./helm-charts/simple-ingress-by-prefix"
  #chart      = "./helm-charts/simple-ingress-by-name"
  chart      = "./helm-charts/simple-ingress-by-name-x2"  #currently you must have 3 active instances to use this
}
