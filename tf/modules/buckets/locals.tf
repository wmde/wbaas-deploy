locals {
    gcs_api_static_bucket_name = "${var.project_prefix}-static"
    gcs_api_static_bucket_backup_name = "${var.project_prefix}-static-backup"
    transfer_service_id = "project-658442145969@storage-transfer-service.iam.gserviceaccount.com"
}
