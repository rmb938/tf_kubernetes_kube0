data "helm_repository" "ingress-nginx" {
  name = "ingress-nginx"
  url  = "https://kubernetes.github.io/ingress-nginx"
}
