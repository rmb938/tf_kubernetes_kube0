module "nfs-namespace" {
  source = "./namespace"
  name   = "nfs"
}

module "nfs-client-provisioner" {
  source = "./nfs-client-provisioner"
}
