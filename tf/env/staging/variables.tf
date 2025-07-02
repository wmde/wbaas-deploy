variable "terraformers" {
  type        = set(string)
  description = "People with access to Terraform state"
  default = [
    "thomas.arrow@wikimedia.de",
    "perside.rosalie@wikimedia.de",
    "jakob.warkotsch@wikimedia.de",
    "dena.erdogan@wikimedia.de",
    "oliver.hyde@wikimedia.de",
    "dat.nguyen@wikimedia.de",
    "leszek.manicki@wikimedia.de",
    "conny.kawohl@wikimedia.de",
    "andrew.kostka@wikimedia.de"
  ]
}

locals {
  staging_cluster_name = "wbaas-2"
  project_id           = "wikibase-cloud"
  email_group          = "wb-cloud-monitoring@wikimedia.de"
  region               = "europe-west3"
  zone                 = "europe-west3-a"
}

variable "mailgun_api_key" {
  type        = string
  description = "User API key to access Mailgun"
  sensitive   = true
}

variable "sql-passwords" {
  type        = set(string)
  description = "SQL passwords to create and send to k8s as secrets"
  default = [
    "staging-replication",
    "staging-api",
    "staging-mediawiki-db-manager",
    "staging-backup-manager",
    "staging-observer"
  ]
}

variable "recaptcha_v3_site_key" {
  type        = string
  description = "Site key to access recaptcha v3"
  sensitive   = true
  default     = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v3_secret" {
  type        = string
  description = "Secret key to access recaptcha v3"
  sensitive   = true
  default     = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}
variable "recaptcha_v2_site_key" {
  type        = string
  description = "Site key to access recaptcha v2"
  sensitive   = true
  default     = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "recaptcha_v2_secret" {
  type        = string
  description = "Secret key to access recaptcha v2"
  sensitive   = true
  default     = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}

variable "tailscale_client_id" {
  type        = string
  description = "Client id for Tailscale access"
  sensitive   = true
  default     = ""
}

variable "tailscale_client_secret" {
  type        = string
  description = "Client secret for Tailscale access"
  sensitive   = true
  default     = ""
}
