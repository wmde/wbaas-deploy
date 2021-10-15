variable "sql-passwords" {
  type    = set(string)
  description = "SQL passwords to create and send to k8s as secrets"
  default = [
      "root",
      "replication",
      "api",
      "mediawiki-db-manager",
      ]
}

variable "recaptcha_site_key" {
  type = string
  description = "Site key to access recaptcha"
  sensitive = true
}

variable "recaptcha_secret_key" {
  type = string
  description = "Secret key to access recaptcha"
  sensitive = true
}
