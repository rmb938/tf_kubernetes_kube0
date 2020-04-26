module "cert-manager-namespace" {
  source = "../modules/namespace"
  name   = "cert-manager"
}

module "cert-manager" {
  source         = "../modules/cert-manager"
  namespace      = module.cert-manager-namespace.namespace_name
  prometheus-crd = module.prometheus.prometheus-operator-crd
}
