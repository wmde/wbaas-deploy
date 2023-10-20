terraform {
  backend "gcs" {
    bucket = "wikibase-cloud-tf-state-staging"
    prefix = "terraform/state"
  }
}

resource "google_storage_bucket" "tf-state-staging" {
  name                        = "wikibase-cloud-tf-state-staging"
  location                    = "EU"
  force_destroy               = false
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

# Give everyone access to the state bucket
resource "google_storage_bucket_iam_member" "tf-state-staging-iam-member" {
  for_each = var.terraformers
  bucket   = google_storage_bucket.tf-state-staging.name
  role     = "roles/storage.objectAdmin"
  member   = "user:${each.value}"
}
