resource "kubernetes_secret" "tailscale-secret" {
  metadata {
    name      = "operator-oauth"
    namespace = "tailscale"
  }

  data = {
    client_id     = var.tailscale_client_id
    client_secret = var.tailscale_client_secret
  }
}
