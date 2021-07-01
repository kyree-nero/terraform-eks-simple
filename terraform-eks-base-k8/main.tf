


# resource "kubernetes_namespace" "ingress" {
#   metadata {
#     name = "ingress"
#   }
# }


# resource "helm_release" "ingress" {
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   #version =  "3.15.2"
#   version =  "3.33.0"
#   namespace = "ingress"

#   depends_on = ["kubernetes_namespace.ingress"]
# }





module "ingress" {
  source = "./ingress"

}