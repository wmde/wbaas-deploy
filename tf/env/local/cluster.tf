resource "kubernetes_config_map" "cluster_config_map" {
  metadata {
    name = "cluster"
  }

  data = {
    ipv4_range = "10.0.0.0/8"
  }
}
