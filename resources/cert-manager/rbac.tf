resource "kubernetes_service_account" "cert-manager" {
  metadata {
    name      = "cert-manager"
    namespace = var.namespace
  }

  automount_service_account_token = true

  # prevent https://github.com/terraform-providers/terraform-provider-kubernetes/issues/292
  lifecycle {
    ignore_changes = [secret]
  }
}

resource "kubernetes_role" "cert-manager-leader-election" {
  metadata {
    name      = "cert-manager:leader-election"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cert-manager-controller"]
    verbs          = ["get", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create"]
  }
}


resource "kubernetes_role_binding" "cert-manager-leader-election" {
  metadata {
    name      = "cert-manager:leader-election"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.cert-manager-leader-election.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "cert-manager-controller-issuers" {
  metadata {
    name = "cert-manager-controller-issuers"
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["issuers", "issuers/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["issuers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role" "cert-manager-controller-clusterissuers" {
  metadata {
    name = "cert-manager-controller-clusterissuers"
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["clusterissuers", "clusterissuers/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["clusterissuers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}


resource "kubernetes_cluster_role" "cert-manager-controller-certificates" {
  metadata {
    name = "cert-manager-controller-certificates"
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates", "certificates/status", "certificaterequests", "certificaterequests/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates", "certificaterequests", "clusterissuers", "issuers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates/finalizers", "certificaterequests/finalizers"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["orders"]
    verbs      = ["create", "delete", "get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}


resource "kubernetes_cluster_role" "cert-manager-controller-orders" {
  metadata {
    name = "cert-manager-controller-orders"
  }


  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["orders", "orders/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["orders", "challenges"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["clusterissuers", "issuers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["challenges"]
    verbs      = ["create", "delete"]
  }

  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["orders/finalizers"]
    verbs      = ["update"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role" "cert-manager-controller-challenges" {
  metadata {
    name = "cert-manager-controller-challenges"
  }

  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["challenges", "challenges/status"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["challenges"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["clusterissuers", "issuers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["acme.cert-manager.io"]
    resources  = ["challenges/finalizers"]
    verbs      = ["update"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch", "create", "delete", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role" "cert-manager-controller-ingress-shim" {
  metadata {
    name = "cert-manager-controller-ingress-shim"
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates", "certificaterequests"]
    verbs      = ["create", "update", "delete"]
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates", "certificaterequests", "issuers", "clusterissuers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses/finalizers"]
    verbs      = ["update"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}

resource "kubernetes_cluster_role_binding" "cert-manager-controller-issuers" {
  metadata {
    name = "cert-manager-controller-issuers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert-manager-controller-issuers.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager.metadata[0].name
    namespace = var.namespace
  }

}

resource "kubernetes_cluster_role_binding" "cert-manager-controller-clusterissuers" {
  metadata {
    name = "cert-manager-controller-clusterissuers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert-manager-controller-clusterissuers.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager.metadata[0].name
    namespace = var.namespace
  }

}

resource "kubernetes_cluster_role_binding" "cert-manager-controller-certificates" {
  metadata {
    name = "cert-manager-controller-certificates"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert-manager-controller-certificates.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager.metadata[0].name
    namespace = var.namespace
  }

}

resource "kubernetes_cluster_role_binding" "cert-manager-controller-orders" {
  metadata {
    name = "cert-manager-controller-orders"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert-manager-controller-orders.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "cert-manager-controller-challenges" {
  metadata {
    name = "cert-manager-controller-challenges"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert-manager-controller-challenges.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "cert-manager-controller-ingress-shim" {
  metadata {
    name = "cert-manager-controller-ingress-shim"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cert-manager-controller-ingress-shim.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cert-manager.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "cert-manager-view" {
  metadata {
    name = "cert-manager-view"
    labels = {
      "rbac.authorization.k8s.io/aggregate-to-view" : "true"
      "rbac.authorization.k8s.io/aggregate-to-edit" : "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" : "true"
    }
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates", "certificaterequests", "issuers"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "cert-manager-edit" {
  metadata {
    name = "cert-manager-edit"
    labels = {
      "rbac.authorization.k8s.io/aggregate-to-edit" : "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" : "true"
    }
  }

  rule {
    api_groups = ["cert-manager.io"]
    resources  = ["certificates", "certificaterequests", "issuers"]
    verbs      = ["create", "delete", "deletecollection", "patch", "update"]
  }
}
