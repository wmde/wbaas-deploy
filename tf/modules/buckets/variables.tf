variable "project_prefix" {
  type = string
  description = "User provided prefix for created buckets"
}

variable "static_bucket_writer_account" {
  type = string
  description = "Google service account that should be granted write access to bucket"
}