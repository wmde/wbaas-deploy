resource "google_compute_resource_policy" "snapshot-nightly" {
  name        = "${var.cluster_name}-nightly-west-to-north-7d-1"
  description = "A nightly snapshot that is retained for 7 days from europe-west3 to the europe-north1. Snapshots kept on disk deletion."
  region      = "europe-west3"

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "03:00"
      }
    }

    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }

    snapshot_properties {
      storage_locations = ["europe-north1"]
      labels            = {}
    }
  }
}
