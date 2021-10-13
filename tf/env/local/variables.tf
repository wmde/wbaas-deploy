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

variable "recaptcha_secret_key" {
  type = string
  description = "Secret key to access recaptcha"
  sensitive = true
  default = "6Lf7R8ocAAAAAIN80eE-hVb0dw7j5u2FXj3KZwv9"
}