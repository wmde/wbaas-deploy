resource "google_dns_managed_zone" "local" {
  description = "DNS zone for domain: wbaas.dev"
  dns_name    = "wbaas.dev."
  name        = "wbaas-dev-local"
  visibility  = "public"

  dnssec_config {
    kind          = "dns#managedZoneDnsSecConfig"
    non_existence = "nsec3"
    state         = "on"

    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 2048
      key_type   = "keySigning"
      kind       = "dns#dnsKeySpec"
    }
    default_key_specs {
      algorithm  = "rsasha256"
      key_length = 1024
      key_type   = "zoneSigning"
      kind       = "dns#dnsKeySpec"
    }
  }
}

resource "google_dns_record_set" "local-NS" {
  managed_zone = google_dns_managed_zone.local.name
  name         = google_dns_managed_zone.local.dns_name
  rrdatas = [
    "ns-cloud-d1.googledomains.com.",
    "ns-cloud-d2.googledomains.com.",
    "ns-cloud-d3.googledomains.com.",
    "ns-cloud-d4.googledomains.com.",
  ]
  ttl  = 21600
  type = "NS"
}

resource "google_dns_record_set" "local-SOA" {
  managed_zone = google_dns_managed_zone.local.name
  name         = google_dns_managed_zone.local.dns_name
  rrdatas = [
    "ns-cloud-d1.googledomains.com. cloud-dns-hostmaster.google.com. 3 21600 3600 259200 300",
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
  ttl  = 300
  type = "A"
}

resource "google_dns_record_set" "local-wildcard-A" {
  managed_zone = google_dns_managed_zone.local.name
  name         = "*.wbaas.dev."
  rrdatas = [
    "127.0.0.1"
  ]
  ttl  = 300
  type = "A"
}
