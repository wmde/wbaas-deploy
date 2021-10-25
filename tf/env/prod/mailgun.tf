resource "mailgun_domain" "default" {
  name          = "wikibase.dev"
  region        = "eu"
  spam_action   = "disabled"
  dkim_key_size   = 1024
}

# Old cluster to be removed
resource "kubernetes_secret" "mailgun-api-key" {
  provider = kubernetes.wbaas-1
  metadata {
    name = "mailgun-api-key"
    namespace = "default"
  }

  data = {
    "key" = var.domain_mailgun_key
  }
}

module "wbaas2-k8s-secrets" {
  source = "./../../modules/k8s-secrets"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  domain_mailgun_key = var.domain_mailgun_key
}