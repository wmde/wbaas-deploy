resource "google_compute_address" "default" {
  name = "wikibase-cloud-ip-01"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}