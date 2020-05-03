module "ingress-namespace" {
  source = "./namespace"
  name   = "ingress"
}

module "ingress-nginx" {
  source              = "./ingress-nginx"
  namespace           = module.ingress-namespace.namespace_name
  cert-manager        = module.cert-manager.cert-manager
  prometheus-operator = module.prometheus.prometheus-operator
}
