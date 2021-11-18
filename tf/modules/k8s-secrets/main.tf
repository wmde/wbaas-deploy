resource "kubernetes_secret" "mailgun-api-key" {
  metadata {
    name = "mailgun-api-key"
    namespace = "default"
  }

  data = {
    "key" = var.domain_mailgun_key
  }
}

# Deprecated per https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-save-key-in-kubernetes-secret---deprecated
# but will do for now...
resource "kubernetes_secret" "dev-api-serviceaccount" {
  metadata {
    name = "dev-api-serviceaccount"
  }
  data = {
    "key.json" = base64decode(var.google_service_account_key_api)
  }
}

# Deprecated per https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-save-key-in-kubernetes-secret---deprecated
# but will do for now...
resource "kubernetes_secret" "clouddns-dns01-solver-svc-acct" {
  metadata {
    name = "clouddns-dns01-solver-svc-acct"
    namespace = "cert-manager"
  }
  data = {
    "key.json" = base64decode(var.google_service_account_key_dns)
  }
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "sql-secrets-passwords" {
  metadata {
    name = "sql-secrets-passwords"
    # TODO default? or staging?
    namespace = "default"
  }

  binary_data = {
    "mariadb-root-password" = base64encode(var.sql_password_root)
    "mariadb-replication-password" = base64encode(var.sql_password_replication)
  }
  
}

# Used by the init script on sql services for user and permissions setup
resource "kubernetes_secret" "sql-secrets-init-passwords" {
  metadata {
    name = "sql-secrets-init-passwords"
    # TODO default? or staging?
    namespace = "default"
  }

  binary_data = {
    "SQL_INIT_PASSWORD_API" = base64encode(var.sql_password_api)
    "SQL_INIT_PASSWORD_MW" = base64encode(var.sql_password_mediawiki_db_manager)
  }
  
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "redis-password" {
  metadata {
    name = "redis-password"
    # Default NS for staging?
    namespace = "default"
  }

  data = {
    "password" = var.redis_password
  }
  
}

resource "kubernetes_secret" "recaptcha-v3-staging-secrets" {
  metadata {
    name = "recaptcha-v3-staging-secrets"
    # default as staging
    namespace = "default"
  }

  data = {
    "site_key" = var.recaptcha_v3_site_key,
    "secret_key" = var.recaptcha_v3_secret
  }
}

resource "kubernetes_secret" "recaptcha-v2-staging-secrets" {
  metadata {
    name = "recaptcha-v2-staging-secrets"
    # default as staging
    namespace = "default"
  }

  data = {
    "site_key" = var.recaptcha_v2_site_key,
    "secret_key" = var.recaptcha_v2_secret
  }
}

resource "kubernetes_secret" "api-passport-keys" {
  metadata {
    name = "api-passport-keys"
    # TODO assuming default is staging
    namespace = "default"
  }

  binary_data = {
    "oauth-public.key" = base64encode(var.api_passport_public_key)
    "oauth-private.key" = base64encode(var.api_passport_private_key)
  }
  
}

resource "kubernetes_secret" "api-app-secrets" {
  metadata {
    name = "api-app-secrets"
    namespace = "default"
  }

  data = {
    "api-app-key" = var.api_app_key
    "api-app-jwt-secret" = var.api_app_jwt_secret
  }
}
