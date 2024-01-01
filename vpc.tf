
resource "google_compute_network" "vpc" {
  name                    = "sql-with-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-with-sql"
  ip_cidr_range = "10.1.0.0/21"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
}

resource "google_compute_global_address" "private-ip-peering" {
  name          = "google-managed-services-custom"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.custom.id
}

resource "google_service_networking_connection" "private-vpc-connection" {
  network = google_compute_network.custom.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private-ip-peering.name
  ]
}
