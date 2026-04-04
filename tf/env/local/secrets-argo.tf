resource "kubernetes_secret" "argo-notifications-secret" {

  metadata {
    namespace = "argocd"
    name      = "argocd-notifications-secret"
  }

  data = {
    "mattermost-token" = var.mattermost_bot_token,
  }
}
