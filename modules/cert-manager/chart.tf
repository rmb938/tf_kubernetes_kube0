data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  namespace = var.namespace

  repository = data.helm_repository.jetstack.metadata[0].name
  chart      = "cert-manager"
  version    = "v0.14.2"

  max_history = 10

  # TODO: depend on crds
  depends_on = [
    var.prometheus-crd,
  ]

  set {
    name  = "global.rbac.create"
    value = "false"
  }

  set {
    name  = "global.leaderElection.namespace"
    value = var.namespace
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "" # TODO: this
  }

  set {
    name  = "nodeSelector.kubernetes\\.io/arch"
    value = "arm"
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
    value = "" # TODO: this
  }

  set {
    name  = "webhook.nodeSelector.kubernetes\\.io/arc"
    value = "arm"
  }

  set {
    name  = "cainjector.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "cainjector.serviceAccount.name"
    value = "" # TODO: this
  }

  set {
    name  = "cainjector.nodeSelector.kubernetes\\.io/arc"
    value = "arm"
  }

}
