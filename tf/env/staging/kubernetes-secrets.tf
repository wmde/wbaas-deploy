module "wbaas2-k8s-secrets" {
  source = "../../modules/k8s-secrets"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  smtp_username                     = mailgun_domain.default.smtp_login
  smtp_password                     = random_password.smtp-password.result
  google_service_account_key_api    = google_service_account_key.dev-api.private_key
  google_service_account_key_dns    = google_service_account_key.certman-dns01-solver.private_key
  sql_password_root                 = random_password.sql-root-password.result
  sql_password_replication          = random_password.sql-passwords["staging-replication"].result
  sql_password_api                  = random_password.sql-passwords["staging-api"].result
  sql_password_mediawiki_db_manager = random_password.sql-passwords["staging-mediawiki-db-manager"].result
  sql_password_backup_manager       = random_password.sql-passwords["staging-backup-manager"].result
  sql_password_observer             = random_password.sql-passwords["staging-observer"].result
  redis_password                    = random_password.redis-password.result
  recaptcha_v3_site_key             = var.recaptcha_v3_site_key
  recaptcha_v3_secret               = var.recaptcha_v3_secret
  recaptcha_v2_site_key             = var.recaptcha_v2_site_key
  recaptcha_v2_secret               = var.recaptcha_v2_secret
  api_passport_public_key           = tls_private_key.api-passport.public_key_pem
  api_passport_private_key          = tls_private_key.api-passport.private_key_pem
  api_app_key                       = random_password.api-app-key.result
  api_app_jwt_secret                = random_password.api-app-jwt-secret.result
  mediawiki_secret_namespaces = [
    "default",
    kubernetes_namespace.api-job-namespace.metadata[0].name,
    kubernetes_namespace.adhoc-job-namespace.metadata[0].name
  ]
  logical_backup_openssl_secret = random_password.logical_backup_random_password.result
}
