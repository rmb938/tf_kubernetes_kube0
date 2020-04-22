resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = var.name
    }

    name = var.name
  }
}
