resource "kubernetes_config_map" "cluster" {
  metadata {
    name = "cluster-config-map"
  }

  data = {
    ipv4_range = "10.0.0.0/8"
  }
}
