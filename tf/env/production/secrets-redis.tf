# Use for sql dbs
resource "random_password" "redis-password" {
  length           = 32
  special          = true
  override_special = "_%@"
  keepers = {
    rotate = 1
  }
}

