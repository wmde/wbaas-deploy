resource "mailgun_domain" "default" {
  name          = "wikibase.dev"
  region        = "eu"
  spam_action   = "disabled"
  dkim_key_size   = 1024
}

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
