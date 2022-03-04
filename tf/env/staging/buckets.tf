module "staging-buckets" {
  source = "./../../modules/buckets"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  project_prefix = "wikibase-dev"
  static_bucket_writer_account = google_service_account.dev-api.email
  backup_bucket_object_admins = var.terraformers
}

