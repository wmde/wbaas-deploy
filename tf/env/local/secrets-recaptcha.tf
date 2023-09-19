resource "kubernetes_secret" "recaptcha-v3-secrets" {
  for_each = toset(["default", "api-jobs", "adhoc-jobs"])
  metadata {
    name = "recaptcha-v3-secrets"
    # default as staging
    namespace = each.value
  }

  data = {
    "site_key"   = var.recaptcha_v3_dev_site_key,
    "secret_key" = var.recaptcha_v3_dev_secret
  }
}

moved {
  from = kubernetes_secret.recaptcha-v3-dev-secrets
  to   = kubernetes_secret.recaptcha-v3-dev-secrets["default"]
}

resource "kubernetes_secret" "recaptcha-v2-secrets" {
  for_each = toset(["default", "api-jobs", "adhoc-jobs"])
  metadata {
    name = "recaptcha-v2-secrets"
    # default as staging
    namespace = each.value
  }

  data = {
    "site_key"   = var.recaptcha_v2_dev_site_key,
    "secret_key" = var.recaptcha_v2_dev_secret
  }
}

moved {
  from = kubernetes_secret.recaptcha-v2-dev-secrets
  to   = kubernetes_secret.recaptcha-v2-dev-secrets["default"]
}
