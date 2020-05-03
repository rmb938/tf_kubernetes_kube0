resource "helm_release" "prometheus-operator-crd" {
  name      = "prometheus-operator-crd"
  namespace = var.namespace

  repository = data.helm_repository.personal.metadata[0].name
  chart      = "prometheus-operator-crd"
  version    = "0.1.1"

  max_history = 5

}

resource "helm_release" "prometheus-operator" {
  name      = "prometheus-operator"
  namespace = var.namespace

  repository = data.helm_repository.personal.metadata[0].name
  chart      = "prometheus-operator"
  version    = "0.1.11"

  max_history = 5

  depends_on = [
    var.cert-manager,
    helm_release.prometheus-operator-crd
  ]

  set {
    name  = "image.repository"
    value = "docker.io/rmb938/prometheus-operator-multi-arch"
  }

  set {
    name  = "prometheusConfigReloader.image.repository"
    value = "docker.io/rmb938/prometheus-config-reloader-multi-arch"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.prometheus-operator.metadata[0].name
  }

  set {
    name  = "rbac.create"
    value = "false"
  }

  set {
    name  = "serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

  set {
    name  = "kubeletService.namespace"
    value = var.system-monitoring-namespace
  }

  # TODO: waiting for a prom operator release that has these flags
  # set {
  #   name  = "webhook.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "webhook.certificate.issuerRef.name"
  #   value = "something"
  # }

  # set {
  #   name  = "webhook.certificate.issuerRef.kind"
  #   value = "something"
  # }

  # set {
  #   name  = "webhook.certificate.issuerRef.group"
  #   value = "something"
  # }

}
