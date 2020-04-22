provider "kubernetes" {
  config_path = "secrets/decrypted/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "secrets/decrypted/kubeconfig"
  }
}
