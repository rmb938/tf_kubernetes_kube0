resource "kubernetes_service_account" "prometheus-operator" {
  metadata {
    name      = "prometheus-operator"
    namespace = var.namespace
  }

  automount_service_account_token = true

  # prevent https://github.com/terraform-providers/terraform-provider-kubernetes/issues/292
  lifecycle {
    ignore_changes = [secret]
  }
}

resource "kubernetes_cluster_role_binding" "prometheus-operator" {
  metadata {
    name = "prometheus-operator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.prometheus-operator.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.prometheus-operator.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "prometheus-operator" {
  metadata {
    name = "prometheus-operator"
  }

  rule {
    api_groups = ["monitoring.coreos.com"]
    resources = [
      "alertmanagers",
      "alertmanagers/finalizers",
      "prometheuses",
      "prometheuses/finalizers",
      "thanosrulers",
      "thanosrulers/finalizers",
      "servicemonitors",
      "podmonitors",
      "prometheusrules"
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets"]
    verbs      = ["*"]
  }

  rule {
    api_groups = [""]
    resources = [
      "configmaps",
      "secrets"
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs = [
      "list",
      "delete"
    ]
  }

  rule {
    api_groups = [""]
    resources = [
      "services",
      "services/finalizers",
      "endpoints"
    ]
    verbs = [
      "get",
      "create",
      "update",
      "delete"
    ]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs = [
      "list",
      "watch"
    ]
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}
