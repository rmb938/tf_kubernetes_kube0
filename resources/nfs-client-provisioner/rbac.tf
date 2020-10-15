resource "kubernetes_service_account" "nfs-client-provisioner" {
  metadata {
    name      = "nfs-client-provisioner"
    namespace = var.namespace
  }

  automount_service_account_token = true

  # prevent https://github.com/terraform-providers/terraform-provider-kubernetes/issues/292
  lifecycle {
    ignore_changes = [secret]
  }
}

resource "kubernetes_cluster_role_binding" "nfs-client-provisioner" {
  metadata {
    name = "nfs-client-provisioner"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.nfs-client-provisioner.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nfs-client-provisioner.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "nfs-client-provisioner" {
  metadata {
    name = "nfs-client-provisioner"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "update", "patch"]
  }

}

resource "kubernetes_role_binding" "nfs-client-provisioner" {
  metadata {
    name      = "nfs-client-provisioner"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.nfs-client-provisioner.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nfs-client-provisioner.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_role" "nfs-client-provisioner" {
  metadata {
    name      = "nfs-client-provisioner"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["endpoints"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
}
