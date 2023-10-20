# Use for sql dbs
resource "random_password" "sql-passwords" {
  for_each         = var.sql-passwords
  length           = 32
  special          = true
  override_special = "_%@"
  keepers = {
    rotate = 2
  }
}
resource "random_password" "sql-root-password" {
  length           = 32
  special          = true
  override_special = "_%@"
}