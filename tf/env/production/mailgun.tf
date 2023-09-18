resource "mailgun_domain" "default" {
  name          = "wikibase.cloud"
  region        = "eu"
  spam_action   = "disabled"
  dkim_key_size = 1024
  smtp_password = random_password.smtp-password.result
  lifecycle {
    ignore_changes = [smtp_password]
  }
}
