# TODO: create CA for webhooks


# Create pub and private key using
# https://www.terraform.io/docs/providers/tls/r/private_key.html

# https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html
# is_ca_certificate=true
# early_renewal_hours=1 year
# validity_period_hours=10 years

# https://www.terraform.io/docs/providers/kubernetes/r/secret.html
# apiVersion: v1
# kind: Secret
# metadata:
#   name: webhook-ca-keypair
#   namespace: cert-manager
# data:
#   tls.crt: 
#   tls.key: 

# https://github.com/banzaicloud/terraform-provider-k8s
# apiVersion: cert-manager.io/v1alpha2
# kind: ClusterIssuer
# metadata:
#   name: webhook-ca
# spec:
#   ca:
#     secretName: webhook-ca-keypair
