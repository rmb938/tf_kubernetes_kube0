resource "kubernetes_resource_quota" "default" {
  metadata {
    name      = "default"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  spec {
    hard = var.quota
  }
}
