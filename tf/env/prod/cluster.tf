resource "google_container_cluster" "wbaas-1" {
  name = "wbaas-1"

    node_pool {
        name                = "default-pool"
        initial_node_count  = 3
        node_count          = 4
        max_pods_per_node   = 110
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
}
