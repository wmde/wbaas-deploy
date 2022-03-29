resource "google_compute_disk" "sql-replica" {
  name  = var.sql-replica-disk-name
  type  = "pd-ssd"
  zone  = "europe-west3-a"
  size  = 60 # GB
  
  lifecycle {
    ignore_changes = [ labels, description ]
    prevent_destroy = true
  }
}

resource "kubernetes_persistent_volume" "sql-replica" {
  provider = kubernetes
  
  metadata {
    name = var.sql-replica-pv-name
  }

  spec {
    capacity = {
      storage = "60Gi"
    }
    
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    claim_ref {
        name = var.sql-replica-disk-name
        namespace = "default"
    }

    persistent_volume_source {
      gce_persistent_disk {
        pd_name = google_compute_disk.sql-replica.name
      }
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.snapshot-nightly.name
  disk = google_compute_disk.sql-replica.name
}
