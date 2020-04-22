resource "kubernetes_limit_range" "default" {
  metadata {
    name = "default"
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = "10m"
        memory = "64Mi"
      }

      default_request = {
        cpu    = "10m"
        memory = "64Mi"
      }
    }
  }
}
