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
  routing_mode            = "REGIONAL"
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