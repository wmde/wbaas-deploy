#TODO change the nane to something dev / staging focused
resource "random_password" "redis-password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "random_password" "cloud-redis-password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

