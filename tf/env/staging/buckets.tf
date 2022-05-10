module "staging-buckets" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/buckets?ref=tf-module-buckets-0"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  project_prefix = "wikibase-dev"
  static_bucket_writer_account = google_service_account.dev-api.email
  user_object_admins = var.terraformers
  gcs_sql_scratch_disk_size_gb = 16
}

