# Mailgun Setup

In order to send transactional emails: e.g. password reset request, signup emails etc. to users we use the email sending service mailgun.

Authentification to this service from developer laptops is done using "API keys" accessible through the mailgun web ui. However, at the time of writing they appear to
semifrequently change the name and scope of these keys. These keys can be set with the opentofu variable named `mailgun_api_key`.

This is done by creating at `terraform.tfvars file in the `production` and `staging` environment `tf` directories and setting the variable
(see: https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

Our opentofu code then creates SMTP credentials that are passed to our services for actually sending mail.
