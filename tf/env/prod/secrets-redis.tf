# Use for sql dbs
resource "random_password" "redis-password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

# Used by the sql service for initial setup
resource "kubernetes_secret" "redis-password" {
  metadata {
    name = "redis-password"
    # Default NS for staging?
    namespace = "default"
  }

  data = {
    "password" = random_password.redis-password.result
  }
  
}
