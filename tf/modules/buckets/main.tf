locals {
  sql_backup_bucket_service_admins = ["serviceAccount:${var.static_bucket_writer_account}"]
  static_backup_bucket_service_admins = [ "serviceAccount:${local.transfer_service_id}" ]
  user_admins = [for i, username in var.user_object_admins : "user:${username}"]
}


## Logical backup bucket
resource "google_storage_bucket" "sql-backup" {
  name          = local.gcs_sql_bucket_backup_name
  location      = "EUROPE-WEST6"
  force_destroy = false

  // only keep versions for N days
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 7
    }
  }
}


# SQL Backup bucket IAM Policy
data "google_iam_policy" "sql-backup-policy" {
  binding {
    role = "roles/storage.objectAdmin"
    members = local.sql_backup_bucket_service_admins
  }

  binding {
    role = "roles/storage.admin"
    members = local.user_admins
  }
}

resource "google_storage_bucket_iam_policy" "sql-backup-bucket-policy" {
  bucket      = local.gcs_sql_bucket_backup_name
  policy_data = data.google_iam_policy.sql-backup-policy.policy_data
  depends_on = [
    google_storage_bucket.sql-backup,
  ]
}


## Backup bucket
resource "google_storage_bucket" "static-backup" {
  name          = local.gcs_api_static_bucket_backup_name
  location      = "EUROPE-NORTH1"
  force_destroy = false

  versioning {
    enabled = "true"
  }

  // only keep versions for N days
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      days_since_noncurrent_time = 7
    }
  }
}

# Backup bucket IAM Policy
data "google_iam_policy" "transfer_job" {
  binding {
      role = "roles/storage.objectAdmin"
      members = local.static_backup_bucket_service_admins
    }

  binding {
    role = "roles/storage.admin"
    members = local.user_admins
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = local.gcs_api_static_bucket_backup_name
  policy_data = data.google_iam_policy.transfer_job.policy_data
}

## Backup job T302563
resource "google_storage_transfer_job" "static-bucket-nightly-backup" {
  description = "Nightly backup of static bucket"

  transfer_spec {
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
