resource "google_project_iam_member" "certman-dns01-solver" {
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.certman-dns01-solver.email}"
  project = local.project_id
}

resource "google_service_account" "certman-dns01-solver" {
    account_id   = "certman-dns01-solver"
    description  = "change dns settings for certman"
    disabled     = false
    display_name = "certman-dns01-solver"
}

# TODO future regular rotation https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-creating-and-regularly-rotating-a-key
resource "google_service_account_key" "certman-dns01-solver" {
    service_account_id = google_service_account.certman-dns01-solver.name

    keepers = {
        rotate = 1
    }
}

resource "google_service_account" "dev-api" {
    account_id   = "wikibase-dev-api"
    disabled     = false
    display_name = "Service Account"
}

# TODO future regular rotation https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-creating-and-regularly-rotating-a-key
resource "google_service_account_key" "dev-api" {
    service_account_id = google_service_account.dev-api.name
    keepers = {
        rotate = 1
    }
}
