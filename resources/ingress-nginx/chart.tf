resource "helm_release" "ingress-nginx" {
  name      = "ingress-nginx"
  namespace = var.namespace

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "3.7.0"

  max_history = 5

  depends_on = [
    var.cert-manager,
    var.prometheus-operator,
    kubernetes_network_policy.allow-any-ingress-nginx,
    kubernetes_network_policy.allow-nginx-ingress-to-defaultbackend,
    kubernetes_network_policy.allow-prometheus-ingress
  ]

  set {
    name  = "controller.config.use-proxy-protocol"
    value = "true"
    type  = "string"
  }

  set {
    name  = "controller.kind"
    value = "DaemonSet"
  }

  set {
    name  = "controller.hostPort.enabled"
    value = "true"
  }

  set {
    name  = "controller.hostPort.ports.http"
    value = "8080"
  }

  set {
    name  = "controller.hostPort.ports.https"
    value = "8443"
  }

  set {
    name  = "controller.nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.serviceMonitor.additionalLabels.prometheus"
    value = "default" # TODO: this
  }

  set {
    name  = "controller.admissionWebhooks.patch.enabled"
    value = "false"
  }

  # TODO: we need a way to get cert-maanger to create the certs
  # how do?
  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "false"
  }

  # We never want the helm chart to do the cert patching
  set {
    name  = "controller.admissionWebhooks.patch.enabled"
    value = "false"
  }

  set {
    name  = "controller.updateStrategy.type"
    value = "RollingUpdate"
  }

  set {
    name  = "controller.updateStrategy.rollingUpdate.maxUnavailable"
    value = "1"
  }

  set {
    name  = "defaultBackend.image.repository"
    value = "k8s.gcr.io/defaultbackend-arm64"
  }

  set {
    name  = "defaultBackend.nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

  set {
    name  = "defaultBackend.enabled"
    value = "true"
  }

  set {
    name  = "defaultBackend.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "defaultBackend.serviceAccount.name"
    value = "default"
  }

  set {
    name  = "rbac.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.ingress-nginx.metadata[0].name
  }
}
