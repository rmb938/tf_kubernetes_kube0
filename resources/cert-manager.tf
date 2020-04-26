module "cert-manager-namespace" {
  source = "../modules/namespace"
  name   = "cert-manager"
}

# TODO: # waiting for https://github.com/jetstack/cert-manager/pull/2841 to be released

# module "cert-manager" {
#   source         = "../modules/cert-manager"
#   namespace      = module.cert-manager-namespace.namespace_name
#   prometheus-crd = module.prometheus.prometheus-operator-crd
# }
