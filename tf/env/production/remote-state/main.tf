provider "google" {
  project     = "wikibase-cloud"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}

# A non public bucket for storing shared terraform state
resource "google_storage_bucket" "tf-state" {
  name          = "wikibase-cloud-tf-state-production"
  location      = "EU"
  force_destroy = false
  uniform_bucket_level_access = true
  versioning {
      enabled = true
  }
}

# Give adam (or someone) initial access
resource "google_storage_bucket_iam_member" "tf-state-iam-member" {
  bucket = google_storage_bucket.tf-state.name
  role = "roles/storage.objectAdmin"
  member = "user:thomas.arrow@wikimedia.de"
}