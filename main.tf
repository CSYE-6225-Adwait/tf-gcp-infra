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
  for_each                = var.vpcs
  name                    = each.value.name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet" {
  for_each      = var.subnet
  name          = each.value.name
  network       = google_compute_network.vpc_network[each.value.vpc].name
  ip_cidr_range = each.value.cidr
}

resource "google_compute_route" "webapp-route" {
  for_each         = var.webapp_route
  name             = each.value.name
  network          = google_compute_network.vpc_network[each.value.vpc].name
  dest_range       = var.webapp_route_dest_range
  next_hop_gateway = "https://www.googleapis.com/compute/v1/projects/${var.project}/global/gateways/default-internet-gateway"
} 

resource "google_compute_firewall" "webapp-firewall" {
  name        = var.firewall_name1
  network     = google_compute_network.vpc_network["vpc-network1"].name
  allow {
    protocol = "tcp"
    ports    = [var.webapp_port1, var.webapp_port2]
  }
  target_tags = ["webapp"]
  source_ranges = [var.source_ranges]
}

resource "google_compute_firewall" "webapp-firewall-deny" {
  name        = var.firewall_name2
  network     = google_compute_network.vpc_network["vpc-network1"].name
  deny {
    protocol = "tcp"
    ports    = [22]
  } 
  source_tags = ["webapp"]
  source_ranges = [var.source_ranges]
}

resource "google_compute_instance" "webapp-instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags = ["webapp"]
  network_interface {
    subnetwork = google_compute_subnetwork.subnet["subnet1"].name
    network = google_compute_network.vpc_network["vpc-network1"].name
    access_config {
      network_tier = "PREMIUM"
    }
  }
  boot_disk {
    auto_delete = true
    initialize_params {
      size = 100
      type = "pd-balanced"
      image = "custom-family"
    }
  }
}
