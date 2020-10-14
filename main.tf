terraform {
  backend "gcs" {
    bucket      = "rmb-lab-tf_kubernetes_kube0"
    credentials = "secrets/decrypted/terraform-state-sa.json"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
}

module "resources" {
  source = "./resources"
}
