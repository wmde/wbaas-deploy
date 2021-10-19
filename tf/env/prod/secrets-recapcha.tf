resource "kubernetes_secret" "recaptcha-v3-staging-secrets" {
  metadata {
    name = "recaptcha-v3-staging-secrets"
    # default as staging
    namespace = "default"
  }

  data = {
    "site_key" = var.recaptcha_v3_staging_site_key,
    "secret_key" = var.recaptcha_v3_staging_secret
  }
}

resource "kubernetes_secret" "recaptcha-v2-staging-secrets" {
  metadata {
    name = "recaptcha-v2-staging-secrets"
    # default as staging
    namespace = "default"
  }

  data = {
    "site_key" = var.recaptcha_v2_staging_site_key,
    "secret_key" = var.recaptcha_v2_staging_secret
  }
}
