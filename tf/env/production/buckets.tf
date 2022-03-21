module "production-buckets" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/buckets/?ref=9ff399e53b55f6be1939c458ea2003956b7baa72"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  project_prefix = "wikibase-cloud"
  static_bucket_writer_account = google_service_account.api.email
  backup_bucket_object_admins = var.terraformers
}

