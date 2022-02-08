module "buckets" {
  source = "./../../modules/buckets"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  project_prefix = "wikibase-dev"
  static_bucket_writer_account = google_service_account.api.email
}
