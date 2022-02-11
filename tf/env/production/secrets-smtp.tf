# Use for sql dbs
resource "random_password" "smtp-password" {
  length           = 32
  special          = true
  override_special = "_%@"
}