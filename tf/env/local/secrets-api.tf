resource "tls_private_key" "api-passport" {
  # RSA 4096 per https://github.com/laravel/passport/blob/10.x/src/Console/KeysCommand.php#L45
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_secret" "api-passport-keys" {
  metadata {
    name      = "api-passport-keys"
    namespace = "default"
  }

  binary_data = {
    "oauth-public.key"  = base64encode(tls_private_key.api-passport.public_key_pem)
    "oauth-private.key" = base64encode(tls_private_key.api-passport.private_key_pem)
  }
}

resource "random_password" "api-app-key" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "random_password" "api-app-jwt-secret" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "api-app-secrets" {
  for_each = toset(["default", "api-jobs", "adhoc-jobs"])
  metadata {
    name      = "api-app-secrets"
    namespace = each.value
  }

  data = {
    "api-app-key"        = random_password.api-app-key.result
    "api-app-jwt-secret" = random_password.api-app-jwt-secret.result
  }
}

moved {
  from = kubernetes_secret.api-app-secrets
  to   = kubernetes_secret.api-app-secrets["default"]
}
