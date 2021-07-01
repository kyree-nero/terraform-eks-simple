
resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}


resource "helm_release" "ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version =  "3.33.0"
  namespace = "ingress"

  depends_on = [kubernetes_namespace.ingress]
}





