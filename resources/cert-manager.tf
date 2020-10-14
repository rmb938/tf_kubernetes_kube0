module "cert-manager-namespace" {
  source = "./namespace"
  name   = "cert-manager"
}

module "cert-manager" {
  source              = "./cert-manager"
  namespace           = module.cert-manager-namespace.namespace_name
  prometheus-operator = module.prometheus.prometheus-operator
}
