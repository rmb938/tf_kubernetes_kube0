resource "kubernetes_service_account" "cert-manager-webhook" {
  metadata {
    name      = "cert-manager-webhook"
    namespace = var.namespace
  }

  automount_service_account_token = true

  # prevent https://github.com/terraform-providers/terraform-provider-kubernetes/issues/292
  lifecycle {
    ignore_changes = [secret]
  }
}


resource "kubernetes_role" "cert-manager-webhook-dynamic-serving" {
  metadata {
    name      = "cert-manager-webhook:dynamic-serving"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["cert-manager-webhook-ca"] # TODO: is this name correct?
    verbs          = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create"]
  }
}

resource "kubernetes_role_binding" "cert-manager-webhook-dynamic-serving" {
  metadata {
    name      = "cert-manager-webhook:dynamic-serving"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.cert-manager-webhook-dynamic-serving.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager-webhook.metadata[0].name
    namespace = var.namespace
  }
}
