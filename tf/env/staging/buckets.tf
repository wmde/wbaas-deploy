module "staging-buckets" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/k8s-secrets?ref=tf-module-buckets-0"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  project_prefix = "wikibase-dev"
  static_bucket_writer_account = google_service_account.dev-api.email
  user_object_admins = var.terraformers
}

