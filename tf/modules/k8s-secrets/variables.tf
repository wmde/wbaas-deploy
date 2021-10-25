variable "domain_mailgun_key" {
  type = string
  description = "User provided domain key for API"
  sensitive = true
  default = "" # apparently this doesn't mean default is empty string but rather default is not defined. This means it won't prompt the user
  # but also won't override the value that is in the state
}