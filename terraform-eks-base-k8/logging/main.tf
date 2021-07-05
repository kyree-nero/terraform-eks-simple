# resource "kubernetes_namespace" "logging" {
#   metadata {
#     name = "amazon-cloudwatch"
#   }
# }

# resource "helm_release" "logging" {
#   name       = "logging-fluendbit"
#   repository = "https://fluent.github.io/helm-charts"
#   chart      = "fluent/fluent-bit"
 
#   version = "1.7.9"
#   namespace = "logging"

#   depends_on = [kubernetes_namespace.logging]
# }

# resource "helm_release" "logging" {
#   name       = "fluentbit"
#   chart      = "./logging/helm-charts/fluentd-cloudwatch"

#   depends_on = [kubernetes_namespace.logging]
# }

resource "helm_release" "logging" {
  name       = "fluentbit"
  chart      = "./logging/helm-charts/fluentd-cloudwatch"

  //depends_on = [kubernetes_namespace.logging]
  
  set {
    name  = "aws.region"
    value = "${var.aws-region}"
  }

  set {
    name  = "cluster.name"
    value = "${var.eks-cluster-name}"
  }
}