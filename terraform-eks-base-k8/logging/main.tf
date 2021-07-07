
resource "helm_release" "logging" {
  name       = "fluentbit"
  chart      = var.logging_type == "fluent-bit" ? "./logging/helm-charts/fluentbit-s3" : "./logging/helm-charts/fluentd-cloudwatch"

  
  set {
    name  = "aws.region"
    value = "${var.aws-region}"
  }

  # needed for fluentd only
  set {
    name  = "cluster.name"
    value = "${var.eks-cluster-name}"
  }
}