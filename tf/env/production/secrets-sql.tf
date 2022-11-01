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

resource "kubernetes_secret" "sql-root-password-old" {
  provider = kubernetes.wbaas-3
  metadata {
    name = "sql-root-password-old"
    namespace = "default"
  }

  binary_data = {
    "mariadb-root-password" = base64encode(random_password.sql-passwords["staging-root"].result)
  }
}