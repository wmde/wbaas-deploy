resource "kubernetes_secret" "recaptcha-v3-dev-secrets" {
  metadata {
    name = "recaptcha-v3-dev-secrets"
    # default as staging
    namespace = "default"
  }

  data = {
    "site_key" = var.recaptcha_v3_dev_site_key,
    "secret_key" = var.recaptcha_v3_dev_secret
  }
}

resource "kubernetes_secret" "recaptcha-v2-dev-secrets" {
  metadata {
    name = "recaptcha-v2-dev-secrets"
    # default as staging
    namespace = "default"
  }

  data = {
    "site_key" = var.recaptcha_v2_dev_site_key,
    "secret_key" = var.recaptcha_v2_dev_secret
  }
}
