resource "tls_private_key" "api-passport" {
  # RSA 4096 per https://github.com/laravel/passport/blob/10.x/src/Console/KeysCommand.php#L45
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_secret" "api-passport-keys" {
  metadata {
    name = "api-passport-keys"
    # TODO assuming default is staging
    namespace = "default"
  }

  binary_data = {
    "oauth-public.key" = base64encode(tls_private_key.api-passport.public_key_pem)
    "oauth-private.key" = base64encode(tls_private_key.api-passport.private_key_pem)
  }
  
}
