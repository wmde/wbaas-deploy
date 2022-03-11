resource "google_project_iam_member" "certman-dns01-solver" {
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.certman-dns01-solver.email}"
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
}

resource "google_service_account" "dev-api" {
    account_id   = "wikibase-dev-api"
    disabled     = false
    display_name = "Service Account"
}

# TODO future regular rotation https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#example-usage-creating-and-regularly-rotating-a-key
resource "google_service_account_key" "dev-api" {
    service_account_id = google_service_account.dev-api.name
}

# module "app-dev-workload-identity" {
#   source                            = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
#   use_existing_gcp_sa               = true
#   name                              = google_service_account.dev-api.account_id
#   project_id                        = local.project_id
#   automount_service_account_token   = true

#   # wait for the custom GSA to have beeen created to force module data source read during apply
#   # https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1059
#   depends_on = [google_service_account.dev-api]
# }