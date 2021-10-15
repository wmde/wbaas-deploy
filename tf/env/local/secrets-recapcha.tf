resource "kubernetes_secret" "recaptcha-secrets" {
  metadata {
    name = "recaptcha-secrets"
    namespace = "default"
  }

  data = {
    "site_key" = var.recaptcha_site_key,
    "secret_key" = var.recaptcha_secret_key
  }
}
