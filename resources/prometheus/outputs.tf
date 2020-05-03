output "prometheus-operator-crd" {
  value = helm_release.prometheus-operator-crd
}

output "prometheus-operator" {
  value = helm_release.prometheus-operator
}
