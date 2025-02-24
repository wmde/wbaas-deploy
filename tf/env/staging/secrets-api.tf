resource "tls_private_key" "api-passport" {
  # RSA 4096 per https://github.com/laravel/passport/blob/10.x/src/Console/KeysCommand.php#L45
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "api-app-key" {
  length           = 32
  special          = true
  override_special = "_%@"
  keepers = {
    rotate = "2"
  }
}

resource "random_password" "api-app-jwt-secret" {
  length           = 32
  special          = true
  override_special = "_%@"
  keepers = {
    rotate = "2"
  }
}
