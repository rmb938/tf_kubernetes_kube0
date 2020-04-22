terraform {
  backend "gcs" {
    bucket      = "rmb-lab-tf_kubernetes_kube0"
    credentials = "secrets/decrypted/terraform-state-sa.json"
  }
}

module "namespaces" {
  source = "./namespaces"
}
