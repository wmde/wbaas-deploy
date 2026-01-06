resource "google_dns_managed_zone" "dev" {
  description = "DNS zone for domain: wikibase.dev"
  dns_name    = "wikibase.dev."
  name        = "wikibase-dev"
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

resource "google_dns_record_set" "dev-NS" {
  managed_zone = google_dns_managed_zone.dev.name
  name         = google_dns_managed_zone.dev.dns_name
  rrdatas = [
    "ns-cloud-d1.googledomains.com.",
    "ns-cloud-d2.googledomains.com.",
    "ns-cloud-d3.googledomains.com.",
    "ns-cloud-d4.googledomains.com.",
  ]
  ttl  = 21600
  type = "NS"
}

resource "google_dns_record_set" "dev-SOA" {
  managed_zone = google_dns_managed_zone.dev.name
  name         = google_dns_managed_zone.dev.dns_name
  rrdatas = [
    "ns-cloud-d1.googledomains.com. cloud-dns-hostmaster.google.com. 3 21600 3600 259200 300",
  ]
  ttl  = 21600
  type = "SOA"
}

resource "google_dns_record_set" "dev-A" {
  managed_zone = google_dns_managed_zone.dev.name
  name         = google_dns_managed_zone.dev.dns_name
  rrdatas = [
    google_compute_address.default.address,
  ]
  ttl  = 300
  type = "A"
}

resource "google_dns_record_set" "dev-wildcard-A" {
  managed_zone = google_dns_managed_zone.dev.name
  name         = "*.wikibase.dev." # TODO: Make this a variable.
  rrdatas = [
    google_compute_address.default.address,
  ]
  ttl  = 300
  type = "A"
}

resource "google_dns_record_set" "dev-MailGun-record" {
  for_each = {
    for record in mailgun_domain.default.sending_records :
    "${record.name}" => record
  }
  name         = "${each.value.name}."
  managed_zone = google_dns_managed_zone.dev.name
  type         = each.value.record_type
  rrdatas      = [replace("\"${each.value.value}\"", "/^\"eu.mailgun.org\"$/", "eu.mailgun.org.")]
}

resource "google_dns_record_set" "dev-dyna-A" {
  managed_zone = google_dns_managed_zone.dev.name
  name         = "sites-1.dyna.wikibase.dev."
  rrdatas = [
    google_compute_address.default.address,
  ]
  ttl  = 300
  type = "A"
}
