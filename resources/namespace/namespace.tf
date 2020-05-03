resource "kubernetes_namespace" "namespace" {
  metadata {
    labels = {
      name = var.name
    }

    name = var.name
  }
}
