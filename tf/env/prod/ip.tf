resource "google_compute_address" "dev-ip" {
  name = "wbaas-1-cluster-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

resource "google_compute_address" "cloud-ip" {
  name = "wbaas-cloud-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}