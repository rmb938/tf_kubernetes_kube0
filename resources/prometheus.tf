module "prometheus-namespace" {
  source = "./namespace"
  name   = "prometheus"
}

module "prometheus" {
  source                      = "./prometheus"
  namespace                   = module.prometheus-namespace.namespace_name
  system-monitoring-namespace = module.system-monitoring-namespace.namespace_name
}
