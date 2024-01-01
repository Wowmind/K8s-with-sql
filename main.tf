resource "google_container_cluster" "private"{
name           = "k8s-cluster"
location       = "us-central1"
network        = google_compute_network.vpc.name
subnetwork     = google_compute_subnetwork.subnet.name

private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_ipv4_cidr_block
  }
master_authorized_networks_config {
    dynamic "cidr_blocks" {
            cidr_block = cidr_blocks.value
        }
  }
// Enable auto-pilot
enable_autopilot = true

Configuration of cluster IP allocation for VPC-native clusters
ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters.
  release_channel {
    channel = "REGULAR"
  }
}

# Create an sql instance
esource "random_string" "db_name_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_sql_database_instance" "mysql" {

  # Instance info
  name             = "mysql-private-${random_string.db_name_suffix.result}"
  region           = var.region
  database_version = var.mysql_database_version

  settings {

    # Region and zonal availability
    availability_type = var.mysql_availability_type
    location_preference {
      zone = var.mysql_location_preference
    }

    # Machine Type
    tier              = var.mysql_machine_type

    # Storage
    disk_size         = var.mysql_default_disk_size

    # Connections
    ip_configuration {
      ipv4_enabled        = false
      private_network     = google_compute_network.custom.id
    }

    # Backups
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "06:00"
    }
  }
  depends_on = [
    google_service_networking_connection.private-vpc-connection
  ]
}
