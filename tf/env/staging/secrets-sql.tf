# Use for sql dbs
resource "random_password" "sql-passwords" {
  for_each = var.sql-passwords
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "random_password" "sql-root-password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "sql-root-old-secret-password" {
  provider = kubernetes.wbaas-2
  metadata {
    name = "sql-root-old-secret-password"
    namespace = "default"
  }

  binary_data = {
    "mariadb-root-password" = base64encode(random_password.sql-passwords["staging-root"].result)
  }
}