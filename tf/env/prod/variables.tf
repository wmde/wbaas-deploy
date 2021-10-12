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
      ]
}

variable "domain_mailgun_key" {
  type = string
  description = "User provided domain key for API"
  sensitive = true
}
