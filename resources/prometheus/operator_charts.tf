resource "helm_release" "prometheus-operator" {
  name      = "prometheus-operator"
  namespace = var.namespace

  repository = local.personal_helm_repo
  chart      = "prometheus-operator"
  version    = "0.2.0"

  max_history = 5

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

}
