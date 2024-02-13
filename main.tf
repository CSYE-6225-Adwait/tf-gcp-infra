terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "webapp" {
  name          = "webapp"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.webapp_ip_cidr_range
}

resource "google_compute_subnetwork" "db" {
  name          = "db"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.db_ip_cidr_range
}

resource "google_compute_route" "webapp-route" {
  name             = "webapp-route"
  network          = google_compute_network.vpc_network.name
  dest_range       = var.webapp_route_dest_range
  next_hop_gateway = "https://www.googleapis.com/compute/v1/projects/${var.project}/global/gateways/default-internet-gateway"  
}

