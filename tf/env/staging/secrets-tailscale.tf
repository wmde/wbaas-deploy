resource "kubernetes_secret" "tailscale-secret" {
  provider = kubernetes.wbaas-2

  metadata {
    name      = "operator-oauth"
    namespace = "tailscale"
  }

  data = {
    client_id     = var.tailscale_client_id
    client_secret = var.tailscale_client_secret
  }
}
