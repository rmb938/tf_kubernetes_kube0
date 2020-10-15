// allow nginx to ingress to xen orchestra
resource "kubernetes_network_policy" "allow-nginx-ingress-to-orchestra" {
  metadata {
    name      = "allow-nginx-ingress-to-orchestra"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name" : "xen-orchestra"
        "app.kubernetes.io/instance" : "xen-orchestra"
      }
    }

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }

      from {
        namespace_selector {
          match_labels = {
            "name" : "ingress"
          }
        }
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
