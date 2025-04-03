resource "google_dns_managed_zone" "local" {
  description = "DNS zone for domain: wbaas.dev"
  dns_name    = "wbaas.dev."
  name        = "wbaas-dev-local"
  visibility  = "public"
}

resource "google_dns_record_set" "local-NS" {
  managed_zone = google_dns_managed_zone.local.name
  name         = google_dns_managed_zone.local.dns_name
  rrdatas = [
    "ns-cloud-a1.googledomains.com.",
    "ns-cloud-a2.googledomains.com.",
    "ns-cloud-a3.googledomains.com.",
    "ns-cloud-a4.googledomains.com.",
  ]
  ttl  = 21600
  type = "NS"
}

resource "google_dns_record_set" "local-SOA" {
  managed_zone = google_dns_managed_zone.local.name
  name         = google_dns_managed_zone.local.dns_name
  rrdatas = [
    "ns-cloud-a1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300",
  ]
  ttl  = 21600
  type = "SOA"
}

resource "google_dns_record_set" "local-A" {
  managed_zone = google_dns_managed_zone.local.name
  name         = google_dns_managed_zone.local.dns_name
  rrdatas = [
    "127.0.0.1"
  ]
  ttl  = 21600
  type = "A"
}

resource "google_dns_record_set" "local-wildcard-CNAME" {
  managed_zone = google_dns_managed_zone.local.name
  name         = "*.wbaas.dev."
  rrdatas = [
    google_dns_managed_zone.local.dns_name
  ]
  ttl  = 21600
  type = "CNAME"
}
