resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  namespace = var.namespace

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.0.3"

  max_history = 5

  depends_on = [
    var.prometheus-operator
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "global.rbac.create"
    value = "false"
  }

  set {
    name  = "global.leaderElection.namespace"
    value = var.namespace
  }

  set {
    name  = "clusterResourceNamespace"
    value = var.namespace
  }

  set {
    name  = "extraArgs"
    value = "{--enable-certificate-owner-ref=true}"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.cert-manager.metadata[0].name
  }

  set {
    name  = "nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

  set {
    name  = "prometheus.servicemonitor.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.servicemonitor.prometheusInstance"
    value = "default" # TODO: this
  }

  set {
    name  = "webhook.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "webhook.serviceAccount.name"
    value = kubernetes_service_account.cert-manager-webhook.metadata[0].name
  }

  set {
    name  = "webhook.nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

  set {
    name  = "cainjector.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "cainjector.serviceAccount.name"
    value = kubernetes_service_account.cert-manager-cainjector.metadata[0].name
  }

  set {
    name  = "cainjector.nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

}
