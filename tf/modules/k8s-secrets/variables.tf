variable "smtp_username" {
  type        = string
  description = "Username for SMTP server"
}

variable "smtp_password" {
  type        = string
  description = "Password for SMTP server"
  sensitive   = true
}

variable "google_service_account_key_api" {
  type        = string
  description = "google service account key for use in the api application"
  sensitive   = true
}

variable "google_service_account_key_dns" {
  type        = string
  description = "google service account key for use by cert-manager to alter DNS records"
  sensitive   = true
}

variable "sql_password_root" {
  type        = string
  description = "SQL root password for staging cluster"
  sensitive   = true
}
variable "sql_password_replication" {
  type        = string
  description = "SQL replication password for staging cluster"
  sensitive   = true
}

variable "sql_password_api" {
  type        = string
  description = "SQL platform api password for staging cluster"
  sensitive   = true
}

variable "sql_password_mediawiki_db_manager" {
  type        = string
  description = "SQL mediawiki db manager password for staging cluster"
  sensitive   = true
}

variable "sql_password_backup_manager" {
  type      = string
  sensitive = true
}

variable "redis_password" {
  type        = string
  description = "redis password for staging cluster"
  sensitive   = true
}

variable "recaptcha_v3_site_key" {
  type        = string
  description = "recaptcha_v3_site_key for the environment"
}
variable "recaptcha_v3_secret" {
  type        = string
  description = "recaptcha_v3_secret for the environment"
  sensitive   = true
}
variable "recaptcha_v2_site_key" {
  type        = string
  description = "recaptcha_v2_site_key for the environment"
}
variable "recaptcha_v2_secret" {
  type        = string
  description = "recaptcha_v2_secret for the environment"
  sensitive   = true
}

variable "api_passport_public_key" {
  type        = string
  description = "Laravel Passport OAuth Public Key for staging cluster"
}

variable "api_passport_private_key" {
  type        = string
  description = "Laravel Passport OAuth Private Key for staging cluster"
  sensitive   = true
}

variable "api_app_key" {
  type        = string
  description = "Laravel API App Key"
  sensitive   = true
}

variable "api_app_jwt_secret" {
  type        = string
  description = "Laravel API App JWT Secret"
  sensitive   = true
}

variable "logical_backup_openssl_secret" {
  type        = string
  description = "Key to encrypt backup tarballs"
  sensitive   = true
}

variable "mediawiki_secret_namespaces" {
  type        = list(string)
  description = "The namespaces to make mediawiki secrets available in"
  sensitive   = false
  default     = ["default"]
}
