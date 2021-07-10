resource "helm_release" "kube-metrics" {
  name       = "kube-metrics"
  chart      = "./monitoring/helm-charts/kube-metrics" 
}

resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
  depends_on = [helm_release.kube-metrics]
}

resource "helm_release" "prometheus" {
  name       = "prometheus-community"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version =  "14.3.1"
  namespace = "prometheus"

  depends_on = [kubernetes_namespace.prometheus]
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
  depends_on = [helm_release.prometheus]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version =  "6.13.7"

  set {
    name  = "persistence.storageClassName"
    value = "gp2"
  }

  set {
    name  = "adminPassword"
    value = "Password"
  }

  set {
    name  = "datasources.\"datasources\\.yaml\".apiVersion"
    value = "1"
  }

  set {
    name  = "datasources.\"datasources\\.yaml\".datasources[0].name"
    value = "Prometheus"
  }

  set {
    name  = "datasources.\"datasources\\.yaml\".datasources[0].type"
    value = "prometheus"
  }

  set {
    name  = "datasources.\"datasources\\.yaml\".datasources[0].url"
    value = "http://prometheus-community-server.prometheus.svc.cluster.local"
  }

  set {
    name  = "datasources.\"datasources\\.yaml\".datasources[0].access"
    value = "proxy"
  }

  set {
    name  = "datasources.\"datasources\\.yaml\".datasources[0].isDefault"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.accessModes"
    value = "{ReadWriteOnce}"
  }

  set {
    name  = "persistence.accessModes"
    value = "{ReadWriteOnce}"
  }

  set {
    name  = "persistence.size"
    value = "8Gi"
  }



  depends_on = [kubernetes_namespace.grafana]
}