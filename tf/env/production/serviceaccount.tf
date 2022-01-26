resource "google_service_account" "certman-dns-cloud-solver" {
    account_id   = "certman-dns-cloud-solver"
    description  = "change dns settings for certman"
    disabled     = false
    display_name = "certman-dns-cloud-solver"
}

# TODO future regular rotation https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-creating-and-regularly-rotating-a-key
resource "google_service_account_key" "certman-dns-cloud-solver" {
    service_account_id = google_service_account.certman-dns-cloud-solver.name
}

resource "google_service_account" "api" {
    account_id   = "wikibase-cloud-api"
    disabled     = false
    display_name = "Service Account"
}

# TODO future regular rotation https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-creating-and-regularly-rotating-a-key
resource "google_service_account_key" "api" {
    service_account_id = google_service_account.api.name
}