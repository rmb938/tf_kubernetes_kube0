resource "kubernetes_network_policy" "deny-ingress" {
  metadata {
    name      = "default-deny-ingress"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]
  }
}
