resource "google_service_account" "certman-dns01-solver" {
    account_id   = "certman-dns01-solver"
    description  = "change dns settings for certman"
    disabled     = false
    display_name = "certman-dns01-solver"
}

# Does not support import, so would need to be a freshly created key
# resource "google_service_account_key" "certman-dns01-solver" {
# }

resource "google_service_account" "dev-api" {
    account_id   = "wikibase-dev-api"
    disabled     = false
    display_name = "Service Account"
}

# TODO future regular rotation https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-creating-and-regularly-rotating-a-key
resource "google_service_account_key" "dev-api" {
    service_account_id = google_service_account.dev-api.name
}