# Use for sql dbs
resource "random_password" "sql-passwords" {
  for_each = var.sql-passwords
  length           = 32
  special          = true
  override_special = "_%@"
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "sql-secrets-passwords" {
  metadata {
    name = "sql-secrets-passwords"
    # TODO default? or staging?
    namespace = "default"
  }

  binary_data = {
    "mariadb-root-password" = base64encode(random_password.sql-passwords["staging-root"].result)
    "mariadb-replication-password" = base64encode(random_password.sql-passwords["staging-replication"].result)
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
    "SQL_INIT_PASSWORD_API" = base64encode(random_password.sql-passwords["staging-api"].result)
    "SQL_INIT_PASSWORD_MW" = base64encode(random_password.sql-passwords["staging-mediawiki-db-manager"].result)
  }
  
}