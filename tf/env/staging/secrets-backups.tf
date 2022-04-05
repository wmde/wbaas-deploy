resource "random_password" "logical_backup_random_password" {
  length           = 32
  special          = true
  override_special = "_%@"
}