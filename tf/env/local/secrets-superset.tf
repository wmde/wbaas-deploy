resource "random_password" "superset-passwords" {
  for_each         = toset(["secret", "admin-password"])
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "superset-secrets" {
  metadata {
    name      = "superset-secrets"
    namespace = "default"
  }

  binary_data = {
    "secret"         = base64encode(random_password.superset-passwords["secret"].result)
    "admin-password" = base64encode(random_password.superset-passwords["admin-password"].result)
  }
}
