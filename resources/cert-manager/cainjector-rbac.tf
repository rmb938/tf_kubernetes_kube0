resource "kubernetes_service_account" "cert-manager-cainjector" {
  metadata {
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }

  automount_service_account_token = true

  # prevent https://github.com/terraform-providers/terraform-provider-kubernetes/issues/292
  lifecycle {
    ignore_changes = [secret]
  }
}

resource "kubernetes_role" "cert-manager-cainjector-leader-election" {
  metadata {
    name      = "cert-manager-cainjector:leader-election"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cert-manager-cainjector-leader-election", "cert-manager-cainjector-leader-election-core"]
    verbs          = ["get", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create"]
  }
}


resource "kubernetes_role_binding" "cert-manager-cainjector-leader-election" {
  metadata {
    name      = "cert-manager-cainjector:leader-election"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.cert-manager-cainjector-leader-election.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager-cainjector.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "cert-manager-cainjector" {
  metadata {
    name = "cert-manager-cainjector"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert-manager-cainjector.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager-cainjector.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "cert-manager-cainjector" {
  metadata {
    name = "cert-manager-cainjector"
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["get", "create", "update", "patch"]
  }

  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations", "mutatingwebhookconfigurations"]
    verbs      = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["apiregistration.k8s.io"]
    resources  = ["apiservices"]
    verbs      = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["auditregistration.k8s.io"]
    resources  = ["auditsinks"]
    verbs      = ["get", "list", "watch", "update"]
  }

}
