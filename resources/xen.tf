module "xen-namespace" {
  source = "./namespace"
  name   = "xen"
}

module "xen-orchestra" {
  source    = "./xen-orchestra"
  namespace = module.xen-namespace.namespace_name
}
