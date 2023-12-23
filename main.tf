resource "google_container_cluster" "private"{
name           = "k8s-cluster"
location       = "us-central1"
network        = google_compute_network.vpc.name
subnetwork     = google_compute_subnetwork.subnet.name
}
