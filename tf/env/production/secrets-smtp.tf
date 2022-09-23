resource "random_password" "smtp-password" {
  length           = 32
  special          = true
  override_special = "_%@"

  keepers = {
    value = 1
  }
}