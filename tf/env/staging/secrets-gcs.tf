resource "google_service_account" "dev-backup-upload" {
  account_id = "dev-backup-upload"
}

resource "google_storage_hmac_key" "dev-backup-upload-key" {
  service_account_email = google_service_account.dev-backup-upload.email
}

resource "google_project_iam_member" "dev-backup-upload" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.dev-backup-upload.email}"
  project = local.project_id
}

resource "kubernetes_secret" "gcs-hmac-key" {
  provider = kubernetes.wbaas-2
  metadata {
    name = "gcs-hmac-key"
  }
  data = {
    "access-key" = google_storage_hmac_key.dev-backup-upload-key.access_id
    "secret-key" = google_storage_hmac_key.dev-backup-upload-key.secret
  }
}

resource "google_storage_hmac_key" "public-assets-key" {
  service_account_email = google_service_account.dev-api.email
}

resource "google_project_iam_member" "public-assets-upload" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.dev-api.email}"
  project = local.project_id
}

resource "kubernetes_secret" "public-assets-hmac-key" {
  provider = kubernetes.wbaas-2
  metadata {
    name = "public-assets-hmac-key"
  }
  data = {
    "access-key" = google_storage_hmac_key.public-assets-key.access_id
    "secret-key" = google_storage_hmac_key.public-assets-key.secret
  }
}
