// allow anything to ingress to nginx ingress
resource "kubernetes_network_policy" "allow-any-ingress-nginx" {
  metadata {
    name      = "allow-any-ingress-nginx"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name" : "ingress-nginx"
        "app.kubernetes.io/instance" : "ingress-nginx"
        "app.kubernetes.io/component" : "controller"
      }
    }

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }
      ports {
        port     = "https"
        protocol = "TCP"
      }

      from {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

// allow nginx to ingress to defaultbackend
resource "kubernetes_network_policy" "allow-nginx-ingress-to-defaultbackend" {
  metadata {
    name      = "allow-nginx-ingress-to-defaultbackend"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name" : "ingress-nginx"
        "app.kubernetes.io/instance" : "ingress-nginx"
        "app.kubernetes.io/component" : "default-backend"
      }
    }

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }

      from {
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" : "ingress-nginx"
            "app.kubernetes.io/instance" : "ingress-nginx"
            "app.kubernetes.io/component" : "controller"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

// allow anything in prometheus namespace to scrape nginx metrics
resource "kubernetes_network_policy" "allow-prometheus-ingress" {
  metadata {
    name      = "allow-prometheus-ingress"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name" : "ingress-nginx"
        "app.kubernetes.io/instance" : "ingress-nginx"
        "app.kubernetes.io/component" : "controller"
      }
    }

    ingress {
      ports {
        port     = "metrics"
        protocol = "TCP"
      }

      from {
        pod_selector {}
        namespace_selector {
          match_labels = {
            "name" : "prometheus"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "helm_release" "ingress-nginx" {
  name      = "ingress-nginx"
  namespace = var.namespace

  repository = data.helm_repository.ingress-nginx.metadata[0].name
  chart      = "ingress-nginx"
  version    = "2.0.3"

  max_history = 5

  depends_on = [
    var.cert-manager,
    var.prometheus-operator,
    kubernetes_network_policy.allow-any-ingress-nginx,
    kubernetes_network_policy.allow-any-ingress-nginx,
    kubernetes_network_policy.allow-nginx-ingress-to-defaultbackend,
    kubernetes_network_policy.allow-prometheus-ingress
  ]

  set_string {
    name  = "controller.config.use-proxy-protocol"
    value = "true"
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
    name  = "controller.resources.requests.cpu"
    value = "400m"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "90Mi"
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = "400m"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "90Mi"
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

  # TODO: this is currently false because we need cert-manager to provision the certs
  # So we need to be able to set annotations
  # and set the secret name and secret keys for the certs
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
