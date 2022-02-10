module "wbaas2-k8s-secrets" {
  source = "./../../modules/k8s-secrets"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  domain_mailgun_key = var.domain_mailgun_key
  google_service_account_key_api = google_service_account_key.dev-api.private_key
  google_service_account_key_dns = google_service_account_key.certman-dns01-solver.private_key
  sql_password_root = random_password.sql-passwords["staging-root"].result
  sql_password_replication = random_password.sql-passwords["staging-replication"].result
  sql_password_api = random_password.sql-passwords["staging-api"].result
  sql_password_mediawiki_db_manager = random_password.sql-passwords["staging-mediawiki-db-manager"].result
  redis_password = random_password.redis-password.result
  recaptcha_v3_site_key = var.recaptcha_v3_site_key
  recaptcha_v3_secret = var.recaptcha_v3_secret
  recaptcha_v2_site_key = var.recaptcha_v2_site_key
  recaptcha_v2_secret = var.recaptcha_v2_secret
  api_passport_public_key = tls_private_key.api-passport.public_key_pem
  api_passport_private_key = tls_private_key.api-passport.private_key_pem
  api_app_key = random_password.api-app-key.result
  api_app_jwt_secret = random_password.api-app-jwt-secret.result
}
