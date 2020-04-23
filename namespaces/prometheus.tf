module "prometheus-namespace" {
  source = "../modules/namespace"
  name   = "prometheus"
}

data "helm_repository" "personal" {
  name = "personal"
  url  = "http://charts.rmb938.com"
}

resource "helm_release" "prometheus-operator-crde" {
  name       = "prometheus-operator-crd"
  repository = data.helm_repository.personal.metadata[0].name
  chart      = "prometheus-operator-crd"
  version    = "0.1.0"

  lifecycle {
    prevent_destroy = true
  }
}
