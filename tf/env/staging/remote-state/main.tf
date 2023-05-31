provider "google" {
  project     = "wikibase-cloud"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}

# A non public bucket for storing shared terraform state
resource "google_storage_bucket" "tf-state" {
  name          = "wikibase-cloud-tf-state-staging"
  location      = "EU"
  force_destroy = false
  uniform_bucket_level_access = true
  versioning {
      enabled = true
  }
}
