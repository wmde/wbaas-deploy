resource "google_service_account" "production-backup-upload" {
  account_id = "production-backup-upload"
}

resource "google_storage_hmac_key" "production-backup-upload-key" {
  service_account_email = google_service_account.production-backup-upload.email
}

resource "google_project_iam_member" "production-backup-upload" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.production-backup-upload.email}"
  project = local.project_id
}

resource "kubernetes_secret" "gcs-hmac-key" {
  provider = kubernetes.wbaas-3
  metadata {
    name = "gcs-hmac-key"
  }
  data = {
    "access-key" = google_storage_hmac_key.production-backup-upload-key.access_id
    "secret-key" = google_storage_hmac_key.production-backup-upload-key.secret
  }
}
