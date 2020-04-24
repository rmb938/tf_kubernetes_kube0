resource "helm_release" "prometheus-operator-crd" {
  name      = "prometheus-operator-crd"
  namespace = module.prometheus-namespace.namespace_name

  repository = data.helm_repository.personal.metadata[0].name
  chart      = "prometheus-operator-crd"
  version    = "0.1.1"

  max_history = 10

}

resource "helm_release" "prometheus-operator" {
  name      = "prometheus-operator"
  namespace = module.prometheus-namespace.namespace_name

  repository = data.helm_repository.personal.metadata[0].name
  chart      = "prometheus-operator"
  version    = "0.1.3"

  max_history = 10

  depends_on = [
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
    value = "arm"
  }

}
