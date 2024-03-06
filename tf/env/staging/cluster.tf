resource "google_container_cluster" "wbaas-2" {
  name                     = "wbaas-2"
  remove_default_node_pool = true
  initial_node_count       = 1
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  maintenance_policy {
    recurring_window {
      # timezone: UTC
      # "Every monday between 04.00 and 16.00 Berlin time"
      start_time = "1970-01-01T02:00:00Z"
      end_time   = "1970-01-01T14:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=MO"
    }
  }
}

resource "google_container_node_pool" "wbaas-2_compute-pool" {
  cluster    = "wbaas-2"
  name       = "compute-pool"
  node_count = 2
  node_locations = [
    "europe-west3-a",
  ]
  node_config {
    disk_size_gb = 32
    disk_type    = "pd-standard"
    machine_type = "n2-standard-4"
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
    preemptible     = false
    service_account = "default"
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

resource "google_container_node_pool" "wbaas-2_search-master-pool" {
  cluster    = "wbaas-2"
  name       = "search-master-pool"
  node_count = 3
  node_locations = [
    "europe-west3-a",
  ]
  node_config {
    disk_size_gb = 32
    disk_type    = "pd-standard"
    machine_type = "n1-standard-1"
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
    preemptible     = false
    service_account = "default"
    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = false
    }
    labels = {
      "wbaas/pool" = "search-master"
    }
    taint = [
      {
        key    = "wbaas/pool"
        value  = "search-master"
        effect = "NO_SCHEDULE"
      }
    ]
  }
  upgrade_settings {
    strategy = "BLUE_GREEN"
    blue_green_settings {
      standard_rollout_policy {
        batch_node_count    = 1
        batch_soak_duration = "16200s"
      }
    }
  }
}

resource "google_container_node_pool" "wbaas-2_search-data-pool" {
  cluster    = "wbaas-2"
  name       = "search-data-pool"
  node_count = 2
  node_locations = [
    "europe-west3-a",
  ]
  node_config {
    disk_size_gb = 32
    disk_type    = "pd-standard"
    machine_type = "n1-highmem-2"
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
    preemptible     = false
    service_account = "default"
    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = false
    }
    labels = {
      "wbaas/pool" = "search-data"
    }
    taint = [
      {
        key    = "wbaas/pool"
        value  = "search-data"
        effect = "NO_SCHEDULE"
      }
    ]
  }
  upgrade_settings {
    strategy = "BLUE_GREEN"
    blue_green_settings {
      standard_rollout_policy {
        batch_node_count    = 1
        batch_soak_duration = "23400s"
      }
    }
  }
}
