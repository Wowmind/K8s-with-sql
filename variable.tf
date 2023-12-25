
variable "project_id" {}

variable "credentials" {}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-b"
}

variable "mysql_availability_type" {
  type = string
  default = "REGIONAL"
}default        = "10.2.0.0/21"
  }

variable "mysql_location_preference" {
  type = string
  default = "us-central1-b"
}

variable "mysql_machine_type" {
  type = string
  default = "db-n1-standard-2"
}

variable "mysql_database_version" {
  type = string
  default = "MYSQL_8_0"
}

variable "mysql_default_disk_size" {
  type = string
  default = "100"
}

variable "mysql_availability_type" {
  type = string
  default = "REGIONAL"
}
