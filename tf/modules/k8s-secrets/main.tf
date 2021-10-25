resource "kubernetes_secret" "mailgun-api-key" {
  metadata {
    name = "mailgun-api-key"
    namespace = "default"
  }

  data = {
    "key" = var.domain_mailgun_key
  }
}
