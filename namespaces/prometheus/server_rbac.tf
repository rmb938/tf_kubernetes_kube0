resource "kubernetes_service_account" "prometheus" {
  metadata {
    name = "prometheus"
  }

  automount_service_account_token = true

  # prevent https://github.com/terraform-providers/terraform-provider-kubernetes/issues/292
  lifecycle {
    ignore_changes = [secret]
  }
}

resource "kubernetes_cluster_role_binding" "prometheus" {
  metadata {
    name = "prometheus"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.prometheus.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.prometheus.metadata[0].name
    namespace = module.prometheus-namespace.namespace_name
  }

  depends_on = [
    kubernetes_service_account.prometheus,
    kubernetes_cluster_role.prometheus
  ]
}

resource "kubernetes_cluster_role" "prometheus" {
  metadata {
    name = "prometheus"
  }

  rule {
    api_groups = [""]
    resources = [
      "nodes",
      "services",
      "endpoints",
      "pods"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get"]
  }

  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }

}
