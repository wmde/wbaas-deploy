# 1. In terraform: create a new bucket called 'wikibase-dev-static-backup'
# 2. In terraform: Add a storage_transfer_job resource that copies from one bucket to the "backup" bucket

## Backup bucket
resource "google_storage_bucket" "static-backup" {
  name          = local.gcs_api_static_bucket_backup_name
  location      = "EUROPE-NORTH1"
  force_destroy = false

  versioning {
    enabled = "true"
  }
}

data "google_iam_policy" "transfer_job" {
  binding {
    role = "roles/storage.legacyBucketReader"

    members = [
      "serviceAccount:${local.transfer_service_id}",
    ]
  }

  binding {
    role = "roles/storage.objectAdmin"

    members = [
      "serviceAccount:${local.transfer_service_id}",
      "user:tobias.andersson@wikimedia.de",
      "user:dat.nguyen@wikimedia.de",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = local.gcs_api_static_bucket_backup_name
  policy_data = "${data.google_iam_policy.transfer_job.policy_data}"
}

## Backup job
resource "google_storage_transfer_job" "static-bucket-nightly-backup" {
  description = "Nightly backup of static bucket"
  # project     = var.project

  transfer_spec {
    # object_conditions {
    #   #max_time_elapsed_since_last_modification = "600s"
    #   #exclude_prefixes = [
    #   #  "requests.gz",
    #   #]
    # }
    transfer_options {
      delete_objects_unique_in_sink = true
    }
    # aws_s3_data_source {
    #   bucket_name = var.aws_s3_bucket
    #   aws_access_key {
    #     access_key_id     = var.aws_access_key
    #     secret_access_key = var.aws_secret_key
    #   }
    # }

    gcs_data_source {
      bucket_name = local.gcs_api_static_bucket_name
      path  = "sites/"
    }
    gcs_data_sink {
      bucket_name = local.gcs_api_static_bucket_backup_name
      path        = "sites/"
    }
  }

  schedule {
    schedule_start_date {
      year  = 2022
      month = 3
      day   = 3
    }
    # schedule_end_date {
    #   year  = 2019
    #   month = 1
    #   day   = 15
    # }
    start_time_of_day {
      hours   = 23
      minutes = 30
      seconds = 0
      nanos   = 0
    }
  }

  depends_on = [
    google_storage_bucket.static-backup,
  ]
}

# resource "google_storage_bucket_access_control" "static-backup-writer" {
#   bucket = google_storage_bucket.static-backup.name
#   role   = "WRITER"
#   entity = "project-658442145969@storage-transfer-service.iam.gserviceaccount.com" 
#   #"user-${var.static_bucket_writer_account}"658442145969
# }

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
