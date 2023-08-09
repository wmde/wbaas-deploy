resource "random_password" "minio-password" {
  length = 32
}

resource "kubernetes_secret" "minio-credentials" {
  metadata {
    name = "minio-credentials"
  }

  binary_data = {
    "rootPassword" = base64encode(random_password.minio-password.result)
  }

  data = {
    "rootUser" = "minio"
  }
}
