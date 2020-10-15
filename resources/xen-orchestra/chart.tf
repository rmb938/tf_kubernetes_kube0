resource "helm_release" "xen-orchestra" {
  name      = "xen-orchestra"
  namespace = var.namespace

  repository = "http://charts.rmb938.com"
  chart      = "xen-orchestra"
  version    = "0.1.1"

  max_history = 5

  set {
    name  = "image.repository"
    value = "ghcr.io/rmb938/xen-orchestra-ce-arm64"
  }

  set {
    name  = "nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = "orchestra.${var.namespace}.kube0.kubernetes.rmb938.me"
  }

  set {
    name  = "storage.className"
    value = "nfs-client"
  }

  set {
    name  = "storage.size"
    value = "30Gi"
  }
}
