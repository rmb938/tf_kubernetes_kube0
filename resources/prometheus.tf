module "prometheus-namespace" {
  source = "../modules/namespace"
  name   = "prometheus"
}

module "prometheus" {
  source    = "./prometheus"
  namespace = module.prometheus-namespace.namespace_name
  # cert-manager = module.cert-manager.cert-manager # TODO: this
  cert-manager = ""
}
