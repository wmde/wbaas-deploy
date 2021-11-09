module "staging-buckets" {
  source = "./../../modules/buckets"
  project_prefix = "wikibase-dev"
  static_bucket_writer_account = google_service_account.dev-api.email
}

module "cloud-buckets" {
  source = "./../../modules/buckets"
  project_prefix = "wikibase-cloud"
  static_bucket_writer_account = google_service_account.cloud-api.email
}
