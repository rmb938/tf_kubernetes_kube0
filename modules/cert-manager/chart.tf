data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

data "helm_repository" "personal" {
  name = "personal"
  url  = "http://charts.rmb938.com"
}

resource "helm_release" "cert-manager-crd" {
  name      = "cert-manager-crd"
  namespace = var.namespace

  repository = data.helm_repository.personal.metadata[0].name
  chart      = "cert-manager-crd"
  version    = "0.1.0"

  max_history = 10
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  namespace = var.namespace

  repository = data.helm_repository.jetstack.metadata[0].name
  chart      = "cert-manager"
  version    = "v0.14.2"

  max_history = 10

  depends_on = [
    var.prometheus-crd,
    helm_release.cert-manager-crd
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
    name  = "extraArgs"
    value = "{--cluster-resource-namespace=${var.namespace},--enable-certificate-owner-ref=true}"
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
