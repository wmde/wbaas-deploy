resource "tls_private_key" "api-passport-legacy" {
  # RSA 4096 per https://github.com/laravel/passport/blob/10.x/src/Console/KeysCommand.php#L45
  algorithm = "RSA"
  rsa_bits  = 4096
}

moved {
  from = tls_private_key.api-passport
  to   = tls_private_key.api-passport-legacy
}

resource "random_password" "api-app-key" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "random_password" "api-app-jwt-secret" {
  length           = 32
  special          = true
  override_special = "_%@"
}
