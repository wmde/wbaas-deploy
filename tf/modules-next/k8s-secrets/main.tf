resource "kubernetes_secret" "smtp-credentials" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name      = "smtp-credentials"
    namespace = each.value
  }

  data = {
    "username" = var.smtp_username
    "password" = var.smtp_password
  }
}

moved {
  from = kubernetes_secret.smtp-credentials
  to   = kubernetes_secret.smtp-credentials["default"]
}

# Deprecated per https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-save-key-in-kubernetes-secret---deprecated
# but will do for now...
resource "kubernetes_secret" "api-serviceaccount" {
  metadata {
    name = "api-serviceaccount"
  }
  data = {
    "key.json" = base64decode(var.google_service_account_key_api)
  }
}

# Deprecated per https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-save-key-in-kubernetes-secret---deprecated
# but will do for now...
resource "kubernetes_secret" "clouddns-dns01-solver-svc-acct" {
  metadata {
    name      = "clouddns-dns01-solver-svc-acct"
    namespace = "cert-manager"
  }
  data = {
    "key.json" = base64decode(var.google_service_account_key_dns)
  }
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "sql-secrets-passwords" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name = "sql-secrets-passwords"
    # TODO default? or staging?
    namespace = each.value
  }

  binary_data = {
    "mariadb-root-password"        = base64encode(var.sql_password_root)
    "mariadb-replication-password" = base64encode(var.sql_password_replication)
  }
}

moved {
  from = kubernetes_secret.sql-secrets-passwords
  to   = kubernetes_secret.sql-secrets-passwords["default"]
}

# Used by the init script on sql services for user and permissions setup
resource "kubernetes_secret" "sql-secrets-init-passwords" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name = "sql-secrets-init-passwords"
    # TODO default? or staging?
    namespace = each.value
  }

  binary_data = {
    "SQL_INIT_PASSWORD_API"     = base64encode(var.sql_password_api)
    "SQL_INIT_PASSWORD_MW"      = base64encode(var.sql_password_mediawiki_db_manager)
    "SQL_INIT_PASSWORD_BACKUPS" = base64encode(var.sql_password_backup_manager)
    "SQL_INIT_OBSERVER"         = base64encode(var.sql_password_observer)
  }

}

moved {
  from = kubernetes_secret.sql-secrets-init-passwords
  to   = kubernetes_secret.sql-secrets-init-passwords["default"]
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "redis-password" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name = "redis-password"
    # Default NS for staging?
    namespace = each.value
  }

  data = {
    "password" = var.redis_password
  }

}

moved {
  from = kubernetes_secret.redis-password
  to   = kubernetes_secret.redis-password["default"]
}

resource "kubernetes_secret" "recaptcha-v3-secrets" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name      = "recaptcha-v3-secrets"
    namespace = each.value
  }

  data = {
    "site_key"   = var.recaptcha_v3_site_key,
    "secret_key" = var.recaptcha_v3_secret
  }
}

moved {
  from = kubernetes_secret.recaptcha-v3-secrets
  to   = kubernetes_secret.recaptcha-v3-secrets["default"]
}

resource "kubernetes_secret" "recaptcha-v2-secrets" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name      = "recaptcha-v2-secrets"
    namespace = each.value
  }

  data = {
    "site_key"   = var.recaptcha_v2_site_key,
    "secret_key" = var.recaptcha_v2_secret
  }
}

moved {
  from = kubernetes_secret.recaptcha-v2-secrets
  to   = kubernetes_secret.recaptcha-v2-secrets["default"]
}

resource "kubernetes_secret" "api-passport-keys" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name = "api-passport-keys"
    # TODO assuming default is staging
    namespace = each.value
  }

  binary_data = {
    "oauth-public.key"  = base64encode(var.api_passport_public_key)
    "oauth-private.key" = base64encode(var.api_passport_private_key)
  }

}

moved {
  from = kubernetes_secret.api-passport-keys
  to   = kubernetes_secret.api-passport-keys["default"]
}

resource "kubernetes_secret" "api-app-secrets" {
  for_each = toset(var.mediawiki_secret_namespaces)
  metadata {
    name      = "api-app-secrets"
    namespace = each.value
  }

  data = {
    "api-app-key"        = var.api_app_key
    "api-app-jwt-secret" = var.api_app_jwt_secret
  }
}

moved {
  from = kubernetes_secret.api-app-secrets
  to   = kubernetes_secret.api-app-secrets["default"]
}

# Used by the wbaas-backup pod/job
resource "kubernetes_secret" "backup-openssl-key" {
  metadata {
    name      = "backup-openssl-key"
    namespace = "default"
  }

  data = {
    "key" = var.logical_backup_openssl_secret
  }
}
