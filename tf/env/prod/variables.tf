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
  description = "API key to access Mailgun"
  sensitive = true
}