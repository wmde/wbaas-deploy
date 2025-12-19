# Generate from kubectl create secret docker-registry \
# techarohq-botstopper \
# --dry-run=client \
# --docker-server ghcr.io \
# --docker-username placeholder-username \
# --docker-password <your-access-token> \

# Where <your-access-token> is a GitHub classic token which has read access to the botstopper repo
# n.b. in Jan 2026 the username is not checked by github hence the placeholder
resource "kubernetes_secret" "botstopper-image-pull" {

  provider = kubernetes.wbaas-2

  metadata {
    namespace = "default"
    name      = "botstopper-image-pull"
  }

  data = {
    ".dockerconfigjson" = var.botstopper_image_pull_json_secret,
  }

  type = "kubernetes.io/dockerconfigjson"
}
