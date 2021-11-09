resource "mailgun_domain" "dev" {
  name          = "wikibase.dev"
  region        = "eu"
  spam_action   = "disabled"
  dkim_key_size   = 1024
}

resource "mailgun_domain" "cloud" {
  name          = "wikibase.cloud"
  region        = "eu"
  spam_action   = "disabled"
  dkim_key_size   = 1024
}
