
# define a snapshot policy
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

data "kubernetes_persistent_volume_claim" "pvc-mariadb-secondary" {
  metadata {
    name = "data-sql-mariadb-secondary-1"
  }
}

# apply wbcloud-nightly snapshot policy to mariadb-secondary pvc
resource "google_compute_region_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.wbcloud-nightly.name
  disk = data.kubernetes_persistent_volume_claim.pvc-mariadb-secondary.spec[0].volume_name
}
