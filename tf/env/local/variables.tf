variable "sql-passwords" {
  type        = set(string)
  description = "SQL passwords to create and send to k8s as secrets"
  default = [
    "root",
    "replication",
    "api",
    "mediawiki-db-manager",
    "backup-manager",
  ]
}

variable "recaptcha_v3_site_key" {
  type        = string
  description = "Site key to access recaptcha v3"
  sensitive   = true
}

variable "recaptcha_v3_secret" {
  type        = string
  description = "Secret key to access recaptcha v3"
  sensitive   = true
}
variable "recaptcha_v2_site_key" {
  type        = string
  description = "Site key to access recaptcha v2"
  sensitive   = true
}

variable "recaptcha_v2_secret" {
  type        = string
  description = "Secret key to access recaptcha v2"
  sensitive   = true
}
