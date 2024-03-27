terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  for_each                        = var.vpcs
  name                            = each.value.name
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
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
  name    = var.firewall_name1
  network = google_compute_network.vpc_network["vpc-network1"].name
  allow {
    protocol = "tcp"
    ports    = [var.webapp_port1, var.webapp_port2]
  }
  target_tags   = [var.app_tag]
  source_ranges = [var.source_ranges]
}

resource "google_compute_firewall" "webapp-firewall-deny" {
  name    = var.firewall_name2
  network = google_compute_network.vpc_network["vpc-network1"].name
  allow {
    protocol = "tcp"
    ports    = [var.deny_port]
  }
  source_tags   = [var.app_tag]
  source_ranges = [var.source_ranges]
}

resource "google_project_service" "service_networking" {
  project = var.project
  service = "servicenetworking.googleapis.com"
}

resource "google_compute_global_address" "private_address" {
  name          = var.gcga_name
  purpose       = var.gcga_purpose
  address_type  = var.gcga_address_type
  prefix_length = var.gcga_prefix_length
  network       = google_compute_network.vpc_network["vpc-network1"].self_link
}

resource "google_service_networking_connection" "private_connection" {
  network                 = google_compute_network.vpc_network["vpc-network1"].name
  service                 = google_project_service.service_networking.service
  reserved_peering_ranges = [google_compute_global_address.private_address.name]
}

resource "google_sql_database_instance" "cloudsql_instance" {
  name                = var.sql_instance_name
  region              = var.region
  database_version    = var.sql_version
  deletion_protection = var.sql_instance_delete_protection

  settings {
    tier      = var.db_instance_teir
    disk_type = var.db_instance_disk_type
    disk_size = var.db_instance_disk_size
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network["vpc-network1"].self_link
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    availability_type = var.db_instance_availability_type
  }
  depends_on = [google_service_networking_connection.private_connection]
}

# CloudSQL Database

resource "google_sql_database" "webapp_database" {
  name     = var.db_name
  instance = google_sql_database_instance.cloudsql_instance.name
}

resource "random_password" "password" {
  length           = 16
  special          = false
}

resource "google_sql_user" "webapp_user" {
  name     = var.db_username
  instance = google_sql_database_instance.cloudsql_instance.name
  password = random_password.password.result

}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_display_name
}

resource "google_project_iam_binding" "service_account_logging_admin" {
  project = var.project
  role    = var.service_account_role1
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "service_account_pub" {
  project = var.project
  role    = var.service_account_role3
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "service_account_monitoring_writer" {
  project = var.project
  role    = var.service_account_role2
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_compute_instance" "webapp-instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [var.app_tag]
  network_interface {
    subnetwork = google_compute_subnetwork.subnet["subnet1"].name
    network    = google_compute_network.vpc_network["vpc-network1"].name
    access_config {
      network_tier = var.instance_network_tier
    }
  }
  boot_disk {
    auto_delete = true
    initialize_params {
      size  = var.instance_size
      type  = var.instance_type
      image = var.instance_family
    }
  }
  service_account {
    email  = google_service_account.service_account.email
    scopes = [var.service_account_scope1,var.service_account_scope2,var.service_account_scope3,var.service_account_scope4]
  }

  depends_on = [
    google_service_account.service_account,
    google_project_iam_binding.service_account_logging_admin,
    google_project_iam_binding.service_account_monitoring_writer,
    google_project_iam_binding.service_account_pub
  ]
  
  metadata_startup_script = <<SCRIPT
      #!/bin/bash
      sudo touch /opt/app/.env
      echo "DATABASEUSERNAME=${google_sql_user.webapp_user.name}" >> /opt/app/.env
      echo "DATABASEURL=${google_sql_database_instance.cloudsql_instance.first_ip_address}" >> /opt/app/.env
      echo "DATABASEPASSWORD=${random_password.password.result}" >> /opt/app/.env
      echo "DATABASENAME=${var.db_name}" >> /opt/app/.env
      echo "ENVRUN=${var.envrun}" >> /opt/app/.env
      SCRIPT

}

data "google_dns_managed_zone" "zone" {
  name = var.zone_name
}
 
resource "google_dns_record_set" "a_record" {
  name         = var.record_name
  type         = var.record_type
  ttl          = var.record_ttl
  managed_zone = data.google_dns_managed_zone.zone.name
 
  rrdatas = [
    google_compute_instance.webapp-instance.network_interface[0].access_config[0].nat_ip
  ]
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vpc_connector_name
  ip_cidr_range = var.vpc_connector_range
  network       = google_compute_network.vpc_network["vpc-network1"].name
}

resource "google_pubsub_topic" "verify_email" {
  name = var.topic_name
}

resource "google_service_account" "pubsub_service_account" {
  account_id   = var.service_ps_name
  display_name = var.service_ps_display
  depends_on = [ google_pubsub_topic.verify_email ]

}
resource "google_project_iam_binding" "pubsub-publisher" {
  project = var.project
  role    = "roles/run.invoker"
  members = ["serviceAccount:${google_service_account.pubsub_service_account.email}"]
}

resource "google_project_iam_binding" "cloud-function-invoker" {
  project = var.project
  role    = "roles/cloudfunctions.invoker"
  members = ["serviceAccount:${google_service_account.pubsub_service_account.email}"]
}

resource "google_project_iam_binding" "cloud-function-mysqlclient" {
  project = var.project
  role    = "roles/cloudsql.client"
  members = ["serviceAccount:${google_service_account.pubsub_service_account.email}"]
}

resource "google_project_iam_binding" "cloud-function-sub" {
  project = var.project
  role    = "roles/pubsub.subscriber"
  members = ["serviceAccount:${google_service_account.pubsub_service_account.email}"]
}
resource "google_project_iam_binding" "cf_service_account_vpc_connector" {
  project = var.project
  role    = "roles/vpcaccess.user"
  members = ["serviceAccount:${google_service_account.pubsub_service_account.email}"]
}

resource "google_cloudfunctions2_function" "verify_email" {
  name         = var.cf_name
  description  = var.cf_desc
  location    = var.region
   build_config {
    runtime     = var.cf_runtime
    entry_point = var.cf_entry_pt
    source {
      storage_source {
        bucket = var.cf_bucket
        object = var.cf_bucket_file
      }
    }
  }

  service_config {
    max_instance_count    = 1
    min_instance_count    = 1
    available_cpu         = var.cf_cpu
    available_memory      = var.cf_memory
    timeout_seconds       = var.cf_ttl
    service_account_email = google_service_account.pubsub_service_account.email
    vpc_connector         = google_vpc_access_connector.connector.self_link

    environment_variables = {
    MAILGUN_API_KEY = var.cf_mailgun_key
    MYSQL_HOST      = google_sql_database_instance.cloudsql_instance.first_ip_address
    MYSQL_USER      = google_sql_user.webapp_user.name
    MYSQL_PASSWORD  = random_password.password.result
    MYSQL_DATABASE  = var.db_name
  }

  }

  
event_trigger {
    event_type            = var.cf_event
    pubsub_topic          = google_pubsub_topic.verify_email.id
    retry_policy          = var.cf_policy
    trigger_region        = var.region
    service_account_email = google_service_account.pubsub_service_account.email
  }

  depends_on = [
    google_sql_database_instance.cloudsql_instance,
    google_pubsub_topic.verify_email,
    google_vpc_access_connector.connector,
    google_project_iam_binding.cf_service_account_vpc_connector,
    google_project_iam_binding.cloud-function-invoker,
    google_project_iam_binding.pubsub-publisher,
    google_pubsub_topic.verify_email,
    google_project_iam_binding.cloud-function-invoker,
    google_project_iam_binding.service_account_pub
  ]
}
