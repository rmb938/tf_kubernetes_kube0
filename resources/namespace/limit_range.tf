resource "kubernetes_limit_range" "default" {
  metadata {
    name      = "default"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = "100m"
        memory = "64Mi"
      }

      default_request = {
        cpu    = "100m"
        memory = "64Mi"
      }
    }
  }
}
