variable "terraformers" {
  type    = set(string)
  description = "People with access to Terraform state"
  default = [
      "adam.shorland@wikimedia.de",
      "thomas.arrow_ext@wikimedia.de",
      "perside.rosalie@wikimedia.de",
      "jakob.warkotsch@wikimedia.de",
      "tobias.andersson@wikimedia.de",
      "deniz.erdogan@wikimedia.de",
      ]
}

locals {
  staging_cluster_name = "wbaas-2"
  cloud_cluster_name = "wbaas-3"
}

variable "mailgun_api_key" {
  type = string
  description = "User API key to access Mailgun"
  sensitive = true
}

variable "sql-passwords" {
  type    = set(string)
  description = "SQL passwords to create and send to k8s as secrets"
  default = [
      "staging-root",
      "staging-replication",
      "staging-api",
      "staging-mediawiki-db-manager",
      "cloud-root",
      "cloud-replication",
      "cloud-api",
      "cloud-mediawiki-db-manager",
      ]
}

variable "dev_domain_mailgun_key" {
  type = string
  description = "User provided domain key for wikbiase.dev for the MailGun API"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v3_staging_site_key" {
  type = string
  description = "Site key to access recaptcha v3"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v3_staging_secret" {
  type = string
  description = "Secret key to access recaptcha v3"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}
variable "recaptcha_v2_staging_site_key" {
  type = string
  description = "Site key to access recaptcha v2"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v2_staging_secret" {
  type = string
  description = "Secret key to access recaptcha v2"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "cloud_domain_mailgun_key" {
  type = string
  description = "User provided domain key for wikibase.cloud for the MailGun API"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v3_cloud_site_key" {
  type = string
  description = "Site key to access recaptcha v3"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v3_cloud_secret" {
  type = string
  description = "Secret key to access recaptcha v3"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}
variable "recaptcha_v2_cloud_site_key" {
  type = string
  description = "Site key to access recaptcha v2"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v2_cloud_secret" {
  type = string
  description = "Secret key to access recaptcha v2"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}