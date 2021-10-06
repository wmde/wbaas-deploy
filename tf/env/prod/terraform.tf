terraform {
  backend "gcs" {
    bucket  = "wikibase-cloud-tf-state-prod"
    prefix  = "terraform/state"
  }
}

# A non public bucket for storing shared terraform state (from remote-state setup)
resource "google_storage_bucket" "tf-state" {
  name          = "wikibase-cloud-tf-state-prod"
  location      = "EU"
  force_destroy = false
  uniform_bucket_level_access = true
  versioning {
      enabled = true
  }
}

# Give everyone access to the state bucket
resource "google_storage_bucket_iam_member" "tf-state-iam-member" {
  for_each = var.terraformers
  bucket = google_storage_bucket.tf-state.name
  role = "roles/storage.objectAdmin"
  member = "user:${each.value}"
}