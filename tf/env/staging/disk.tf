resource "google_compute_disk" "data-sql-mariadb-secondary" {
  name  = "data-sql-mariadb-secondary-0"
  type  = "pd-ssd"
  zone  = "europe-west3-a"
  size  = 60 # GB
  physical_block_size_bytes = 4096
  project = local.project_id
  lifecycle {
    ignore_changes = [ labels, description ]
    prevent_destroy = true
  }
}

resource "kubernetes_persistent_volume" "data-sql-mariadb-secondary" {

    provider = kubernetes.wbaas-2
  metadata {
    name = "pv-data-sql-mariadb-secondary-0"
  }
  spec {
    capacity = {
      storage = "60Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "premium-rwo"
    persistent_volume_reclaim_policy = "Delete"

    claim_ref {
        name = "data-sql-mariadb-secondary-0"
        namespace = "default"
    }

    persistent_volume_source {
      gce_persistent_disk {
        pd_name = google_compute_disk.data-sql-mariadb-secondary.name
      }
    }
  }
}

resource "google_compute_resource_policy" "wbcloud-nightly" {
  name   = "wbcloud-nightly-west-to-north-7d-1"
  description = "A nightly snapshot that is retained for 7 days from europe-west3 to the europe-north1. Snapshots kept on disk deletion."
  region = "europe-west3"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle  = 1
        start_time     = "03:00"
      }
    }
    
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }

    snapshot_properties {
      storage_locations = ["europe-north1"]
    }
  }
}

resource "google_compute_region_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.wbcloud-nightly.name
  disk = google_compute_disk.data-sql-mariadb-secondary.name
}
