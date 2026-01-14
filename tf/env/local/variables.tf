variable "sql-passwords" {
  type        = set(string)
  description = "SQL passwords to create and send to k8s as secrets"
  default = [
    "root",
    "replication",
    "api",
    "mediawiki-db-manager",
    "backup-manager",
    "observer"
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

variable "botstopper_image_pull_json_secret" {
  type        = string
  description = "String contents of a docker/config.json to pull the botstopper image generated using `kubectl create secret` as per the botstopper docs"
  sensitive   = true
}
