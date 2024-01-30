module "production-buckets" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/buckets/?ref=tf-module-buckets-3"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  project_prefix               = "wikibase-cloud"
  static_bucket_writer_account = google_service_account.api.email
  user_object_admins           = var.terraformers
}

