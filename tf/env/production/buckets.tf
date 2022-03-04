module "production-buckets" {
  source = "./../../modules/buckets"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  project_prefix = "wikibase-cloud"
  static_bucket_writer_account = google_service_account.api.email
  backup_bucket_object_admins = var.terraformers
}

