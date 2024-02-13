variable "project" {}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "webapp_ip_cidr_range" {
}

variable "db_ip_cidr_range" {
}

variable "webapp_route_dest_range" {
}
