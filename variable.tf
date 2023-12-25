
variable "project_id" {}

variable "credentials" {}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-b"
}

variable "gke_master_ipv4_cidr_block" {
default        = "10.2.0.0/21
  }
