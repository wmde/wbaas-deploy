variable "project_prefix" {
  type = string
  description = "User provided prefix for created buckets"
}

variable "static_bucket_writer_account" {
  type = string
  description = "Google service account that should be granted write access to bucket"
}

variable "user_object_admins" {
  type = set(string)
  description = "Users who have access to the backup buckets"
}

variable "gcs_sql_scratch_disk_size_gb" {
  type = number
  description = "Number of gigabytes of disk available for producing backups"
}