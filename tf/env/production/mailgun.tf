resource "mailgun_domain" "default" {
  name          = "wikibase.cloud"
  region        = "eu"
  spam_action   = "disabled"
  dkim_key_size   = 1024
}

data "mailgun_domain" "default" {
  name = "${mailgun_domain.default.name}"
}
