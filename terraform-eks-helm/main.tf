# resource "kubectl_manifest" "kub_app_deployment" {
#     yaml_body = file("${path.root}/app-deployment.yaml")
# }

resource "helm_release" "simple_app" {
  name       = "simple-chart"
  chart      = "./helm-charts/simple-helm-with-service"
}
