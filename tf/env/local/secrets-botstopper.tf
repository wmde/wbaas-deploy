resource "kubernetes_secret" "botstopper-image-pull" {

  metadata {
    namespace = "default"
    name      = "botstopper-image-pull"
  }

  binary_data = {
    ".dockerconfigjson" = var.botstopper_image_pull_json_secret,
  }

  type = "kubernetes.io/dockerconfigjson"
}
