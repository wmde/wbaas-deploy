resource "google_dns_managed_zone" "cloud" {
    description   = "Zone for wikibase.cloud"
    dns_name      = "wikibase.cloud."
    name          = "wikibase-cloud-zone"
    visibility    = "public"
}

resource "google_dns_record_set" "cloud-NS" {
    managed_zone = google_dns_managed_zone.cloud.name
    name         = google_dns_managed_zone.cloud.dns_name
    rrdatas      = [
        "ns-cloud-b1.googledomains.com.",
        "ns-cloud-b2.googledomains.com.",
        "ns-cloud-b3.googledomains.com.",
        "ns-cloud-b4.googledomains.com.",
    ]
    ttl          = 21600
    type         = "NS"
}
resource "google_dns_record_set" "cloud-SOA" {
    managed_zone = google_dns_managed_zone.cloud.name
    name         = google_dns_managed_zone.cloud.dns_name
    rrdatas      = [
        "ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300",
    ]
    ttl          = 21600
    type         = "SOA"
}