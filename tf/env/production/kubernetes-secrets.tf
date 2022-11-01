module "wbaas-k8s-secrets" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/k8s-secrets?ref=tf-module-k8s-secrets-1"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  smtp_username = mailgun_domain.default.smtp_login
  smtp_password = random_password.smtp-password.result
  google_service_account_key_api = google_service_account_key.api.private_key
  google_service_account_key_dns = google_service_account_key.certman-dns-cloud-solver.private_key
  sql_password_root = random_password.sql-root-password.result
  sql_password_replication = random_password.sql-passwords["production-replication"].result
  sql_password_api = random_password.sql-passwords["production-api"].result
  sql_password_mediawiki_db_manager = random_password.sql-passwords["production-mediawiki-db-manager"].result
  sql_password_backup_manager = random_password.sql-passwords["production-backup-manager"].result
  redis_password = random_password.redis-password.result
  recaptcha_v3_site_key = var.recaptcha_v3_site_key
  recaptcha_v3_secret = var.recaptcha_v3_secret
  recaptcha_v2_site_key = var.recaptcha_v2_site_key
  recaptcha_v2_secret = var.recaptcha_v2_secret
  api_passport_public_key = tls_private_key.api-passport.public_key_pem
  api_passport_private_key = tls_private_key.api-passport.private_key_pem
  api_app_key = random_password.api-app-key.result
  api_app_jwt_secret = random_password.api-app-jwt-secret.result
  logical_backup_openssl_secret = random_password.logical_backup_random_password.result
}

