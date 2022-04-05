# Used by the wbaas-backup pod/job
resource "kubernetes_secret" "backup-openssl-key" {
  metadata {
    name = "backup-openssl-key"
    namespace = "default"
  }

  data = {
    "key" = "development-password"
  }
}
