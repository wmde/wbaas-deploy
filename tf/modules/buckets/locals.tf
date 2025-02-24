
data "google_project" "project" {}
locals {
  gcs_api_static_bucket_name        = "${var.project_prefix}-static"
  gcs_api_static_bucket_backup_name = "${var.project_prefix}-static-backup"
  gcs_sql_bucket_backup_name        = "${var.project_prefix}-sql-backup"
  transfer_service_id               = "project-${data.google_project.project.number}@storage-transfer-service.iam.gserviceaccount.com"
}
