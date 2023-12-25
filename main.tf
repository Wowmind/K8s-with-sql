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
resource "google_compute_global_address" "private-ip-peering" {
  name          = "google-managed-services-custom"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private-vpc-connection" {
  network = google_compute_network.vpc.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private-ip-peering.name
  ]
}
