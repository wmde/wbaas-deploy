# Use for sql dbs
resource "random_password" "redis-password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "redis-password" {
  for_each = toset(["default", "api-jobs", "adhoc-jobs"])
  metadata {
    name      = "redis-password"
    namespace = each.value
  }

  binary_data = {
    "password" = base64encode(random_password.redis-password.result)
  }

}

moved {
  from = kubernetes_secret.redis-password
  to   = kubernetes_secret.redis-password["default"]
}
