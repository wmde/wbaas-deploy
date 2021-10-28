module "staging-buckets" {
  source = "./../../modules/buckets"
  project_prefix = "wikibase-dev"
  static_bucket_writer_account = google_service_account.dev-api.email
}

