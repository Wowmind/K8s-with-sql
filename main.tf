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
   


}
