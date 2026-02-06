resource "google_dns_managed_zone" "cloud" {
  description = "Zone for wikibase.cloud"
  dns_name    = "wikibase.cloud." # TODO: Make this a variable.
  name        = "wikibase-cloud-zone"
  visibility  = "public"
}

resource "google_dns_record_set" "cloud-NS" {
  managed_zone = google_dns_managed_zone.cloud.name
  name         = google_dns_managed_zone.cloud.dns_name
  rrdatas = [
    "ns-cloud-b1.googledomains.com.",
    "ns-cloud-b2.googledomains.com.",
    "ns-cloud-b3.googledomains.com.",
    "ns-cloud-b4.googledomains.com.",
  ]
  ttl  = 21600
  type = "NS"
}
resource "google_dns_record_set" "cloud-SOA" {
  managed_zone = google_dns_managed_zone.cloud.name
  name         = google_dns_managed_zone.cloud.dns_name
  rrdatas = [
    "ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300",
  ]
  ttl  = 21600
  type = "SOA"
}

resource "google_dns_record_set" "cloud-A" {
  managed_zone = google_dns_managed_zone.cloud.name
  name         = google_dns_managed_zone.cloud.dns_name
  rrdatas = [
    google_compute_address.default.address,
  ]
  ttl  = 300
  type = "A"
}

resource "google_dns_record_set" "cloud-wildcard-A" {
  managed_zone = google_dns_managed_zone.cloud.name
  name         = "*.wikibase.cloud." # TODO: Make this a variable.
  rrdatas = [
    google_compute_address.default.address,
  ]
  ttl  = 300
  type = "A"
}

resource "google_dns_record_set" "cloud-MailGun-record" {
  for_each = {
    for record in mailgun_domain.default.sending_records :
    "${record.name}-${record.record_type}-${md5(record.value)}" => record
  }
  name         = "${each.value.name}."
  managed_zone = google_dns_managed_zone.cloud.name
  type         = each.value.record_type
  rrdatas      = [replace("\"${each.value.value}\"", "/^\"eu.mailgun.org\"$/", "eu.mailgun.org.")]
}

resource "google_dns_record_set" "cloud-dyna-A" {
  managed_zone = google_dns_managed_zone.cloud.name
  name         = "sites-1.dyna.wikibase.cloud."
  rrdatas = [
    google_compute_address.default.address,
  ]
  ttl  = 300
  type = "A"
}
