resource "google_compute_address" "default" {
  name = "wbaas-1-cluster-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}