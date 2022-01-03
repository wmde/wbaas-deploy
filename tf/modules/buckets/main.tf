resource "google_storage_bucket" "static" {
  name          = local.gcs_api_static_bucket_name
  location      = "EU"
  force_destroy = false
}

resource "google_storage_bucket_access_control" "static-public" {
  bucket = google_storage_bucket.static.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_access_control" "static-writer" {
  bucket = google_storage_bucket.static.name
  role   = "WRITER"
  entity = "user-${var.static_bucket_writer_account}"
}

resource "kubernetes_config_map" "storage-bucket" {
  metadata {
    name = "storage-bucket"
  }

  data = {
    gcs_api_static_bucket_name = local.gcs_api_static_bucket_name
  }
}
