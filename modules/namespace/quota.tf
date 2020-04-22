resource "kubernetes_resource_quota" "default" {
  metadata {
    name = "default"
  }

  spec {
    hard = var.quota
  }
}
