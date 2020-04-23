module "prometheus-namespace" {
  source = "../modules/namespace"
  name   = "prometheus"
}

data "helm_repository" "personal" {
  name = "personal"
  url  = "http://charts.rmb938.com"
}

resource "helm_release" "prometheus-operator-crd" {
  name      = "prometheus-operator-crd"
  namespace = module.prometheus-namespace.namespace_name

  repository = data.helm_repository.personal.metadata[0].name
  chart      = "prometheus-operator-crd"
  version    = "0.1.1"

  max_history = 10

  lifecycle {
    prevent_destroy = true
  }
}

resource "helm_release" "prometheus-operator" {
  name      = "prometheus-operator"
  namespace = module.prometheus-namespace.namespace_name

  repository = data.helm_repository.personal.metadata[0].name
  chart      = "prometheus-operator"
  version    = "0.1.1"

  max_history = 10

  depends_on = [
    helm_release.prometheus-operator-crd
  ]
}
