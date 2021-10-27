resource "google_storage_bucket" "static" {
  name          = "${var.project_prefix}-static"
  location      = "EU"
  force_destroy = false
}

resource "google_storage_bucket_access_control" "static-public" {
  bucket = google_storage_bucket.static.name
  role   = "READER"
  entity = "allUsers"
}