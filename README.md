# tf_kubernetes_kube0
Terraform for kubernetes cluster Kube0

## Requirements
  * GCS Bucket with Service Account
    * `Storage Legacy Bucket Owner` 
  * `kubectl apply -f bootstrap.yaml`
    * Create a kubeconfig using the service account token from `bootstrap/terraform`
