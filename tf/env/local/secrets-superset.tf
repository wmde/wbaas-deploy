resource "random_password" "superset-secret-key" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "superset-secrets" {
  metadata {
    name      = "superset-secrets"
    namespace = "superset"
  }
  data = {
    SUPERSET_SECRET_KEY = random_password.superset-secret-key.result
  }
}
