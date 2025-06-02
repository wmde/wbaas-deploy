# Use for sql dbs
resource "random_password" "sql-passwords" {
  for_each         = var.sql-passwords
  length           = 32
  special          = true
  override_special = "_%@"
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "sql-secrets-passwords" {
  for_each = toset([
    "default",
    kubernetes_namespace.api-job-namespace.metadata[0].name,
    kubernetes_namespace.adhoc-job-namespace.metadata[0].name,
  ])
  metadata {
    name      = "sql-secrets-passwords"
    namespace = each.value
  }

  binary_data = {
    "mariadb-root-password"        = base64encode(random_password.sql-passwords["root"].result)
    "mariadb-replication-password" = base64encode(random_password.sql-passwords["replication"].result)
  }
}

moved {
  from = kubernetes_secret.sql-secrets-passwords
  to   = kubernetes_secret.sql-secrets-passwords["default"]
}

# Used by the init script on sql services for user and permissions setup
resource "kubernetes_secret" "sql-secrets-init-passwords" {
  for_each = toset(["default", "api-jobs", "adhoc-jobs"])
  metadata {
    name      = "sql-secrets-init-passwords"
    namespace = each.value
  }

  binary_data = {
    "SQL_INIT_PASSWORD_API"     = base64encode(random_password.sql-passwords["api"].result)
    "SQL_INIT_PASSWORD_MW"      = base64encode(random_password.sql-passwords["mediawiki-db-manager"].result)
    "SQL_INIT_PASSWORD_BACKUPS" = base64encode(random_password.sql-passwords["backup-manager"].result)
    "SQL_INIT_OBSERVER"         = base64encode(random_password.sql-passwords["observer"].result)
  }
}

moved {
  from = kubernetes_secret.sql-secrets-init-passwords
  to   = kubernetes_secret.sql-secrets-init-passwords["default"]
}
