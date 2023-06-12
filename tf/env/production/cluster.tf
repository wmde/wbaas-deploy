resource "google_container_cluster" "wbaas-3" {
  name = "wbaas-3"
  remove_default_node_pool = true
  initial_node_count       = 1
  monitoring_config {
    enable_components = [ "SYSTEM_COMPONENTS" ]
    managed_prometheus {
      enabled = true
    }
  }

  maintenance_policy {
    recurring_window {
      # timezone: UTC
      # "Every monday between 9.00 and 16.00 Berlin time"
      start_time = "2023-06-14T07:00:00Z"
      end_time   = "2023-06-14T14:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=MO"
    }
  }
}

resource "google_container_node_pool" "wbaas-3_highmem-16" {
    cluster = "wbaas-3"
    name                = "n2-highmem-16-pool"
    node_count          = 3
    node_locations      = [
        "europe-west3-a",
    ]
    node_config {
        disk_size_gb      = 32
        disk_type         = "pd-standard"
        machine_type      = "n2-highmem-16"
        metadata          = {
            "disable-legacy-endpoints" = "true"
        }
        oauth_scopes      = [
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/service.management.readonly",
            "https://www.googleapis.com/auth/servicecontrol",
            "https://www.googleapis.com/auth/trace.append",
        ]
        preemptible       = false
        service_account   = "default"
        shielded_instance_config {
            enable_integrity_monitoring = true
            enable_secure_boot          = false
        }
    }

    upgrade_settings {
        max_surge       = 1
        max_unavailable = 0
    }
}
