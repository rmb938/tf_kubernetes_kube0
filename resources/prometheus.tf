module "prometheus-namespace" {
  source = "./namespace"
  name   = "prometheus"
}

module "prometheus" {
  source                      = "./prometheus"
  namespace                   = module.prometheus-namespace.namespace_name
  cert-manager                = module.cert-manager.cert-manager
  system-monitoring-namespace = module.system-monitoring-namespace.namespace_name
}
