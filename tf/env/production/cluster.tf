resource "google_container_cluster" "wbaas-3" {
  name = "wbaas-3"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "wbaas-3_medium" {
    cluster = "wbaas-3"
    name                = "medium-pool"
    node_count          = 2
    node_locations      = [
        "europe-west3-a",
    ]
    node_config {
        disk_size_gb      = 32
        disk_type         = "pd-standard"
        machine_type      = "e2-medium"
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


resource "google_container_node_pool" "wbaas-3_standard" {
    cluster = "wbaas-3"
    name                = "standard-pool"
    node_count          = 3
    node_locations      = [
        "europe-west3-a",
    ]
    node_config {
        disk_size_gb      = 32
        disk_type         = "pd-standard"
        machine_type      = "e2-standard-2"
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