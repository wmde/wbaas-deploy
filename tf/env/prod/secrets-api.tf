resource "tls_private_key" "api-passport" {
  # RSA 4096 per https://github.com/laravel/passport/blob/10.x/src/Console/KeysCommand.php#L45
  algorithm = "RSA"
  rsa_bits  = 4096
}
