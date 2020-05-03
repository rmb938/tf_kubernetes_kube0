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
