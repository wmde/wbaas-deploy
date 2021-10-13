resource "kubernetes_secret" "recaptcha-secret-key" {
  metadata {
    name = "recaptcha-secret-key"
    namespace = "default"
  }

  data = {
    "recaptcha_secret_key" = var.recaptcha_secret_key
  }
}
