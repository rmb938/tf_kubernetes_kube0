resource "helm_release" "nfs-client-provisioner" {
  name      = "nfs-client-provisioner"
  namespace = var.namespace

  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nfs-client-provisioner"
  version    = "1.2.9"

  max_history = 5

  set {
    name  = "image.repository"
    value = "quay.io/external_storage/nfs-client-provisioner-arm"
  }

  set {
    name  = "nodeSelector.kubernetes\\.io/arch"
    value = "arm64"
  }

  set {
    name  = "storageClass.archiveOnDelete"
    value = "false"
  }

  set {
    name  = "nfs.server"
    value = "freenas.rmb938.me"
  }

  set {
    name  = "nfs.path"
    value = "/mnt/tank/kubernetes"
  }

  set {
    name  = "rbac.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.nfs-client-provisioner.metadata[0].name
  }
}
