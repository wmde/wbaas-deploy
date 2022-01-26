resource "mailgun_domain" "default" {
  name          = "wikibase.dev"
  region        = "eu"
  spam_action   = "disabled"
  dkim_key_size   = 1024
}
