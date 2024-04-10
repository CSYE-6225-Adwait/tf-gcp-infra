variable "project" {}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "webapp_ip_cidr_range" {
}
variable "envrun" {
  default = "PRODUCTION"
  
}
variable "db_ip_cidr_range" {
}

variable "webapp_route_dest_range" {
}

variable "routing_mode" {
}

variable "firewall_name1" {
  default = "webapp-firewall"
}

variable "firewall_name2" {
  default = "webapp-firewall-deny"
}

variable "instance_name" {
  default = "webapp-instance"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "deny_port" {
  default = 22
}

variable "app_tag" {
  default = "webapp"
}

variable "s_account" {
  default = "service-143684562246@compute-system.iam.gserviceaccount.com"
}

variable "gcga_name" {
  default = "private-address"
}

variable "gcga_purpose" {
  default = "VPC_PEERING"
}

variable "gcga_address_type" {
  default = "INTERNAL"
}

variable "gcga_prefix_length" {
  default = 16
}

variable "sql_instance_name" {
  default = "webapp-cloudsql-instance"
}

variable "sql_version" {
  default = "MYSQL_8_0"
}

variable "sql_instance_delete_protection" {
  default = false
}

variable "db_instance_teir" {
  default = "db-n1-standard-1"
}

variable "db_instance_disk_type" {
  default = "pd-ssd"
}

variable "db_instance_disk_size" {
  default = 100
}

variable "db_instance_availability_type" {
  default = "REGIONAL"
}

variable "db_name" {
  default = "webapp"
}

variable "db_username" {
  default = "webapp"
}

variable "instance_network_tier" {
  default = "PREMIUM"
}

variable "instance_size" {
  default = 20
}

variable "instance_type" {
  default = "pd-balanced"
}

variable "instance_family" {
  default = "custom-family"
}

variable "service_account_id" {
  default = "webapp-service-account"
}

variable "service_display_name" {
  default = "Webapp Service Account"
}

variable "service_account_role1" {
  default = "roles/logging.admin"
}

variable "service_account_role2" {
  default = "roles/monitoring.metricWriter"
}

variable "service_account_role3" {
  default = "roles/pubsub.publisher"
}

variable "service_account_scope1" {
  default = "logging-write"
}

variable "service_account_scope2" {
  default = "monitoring-write"
}

variable "service_account_scope3" {
  default = "cloud-platform"
}

variable "service_account_scope4" {
  default = "pubsub"
}

variable "zone_name" {
  default = "zone-adwaitchangan"
}

variable "record_name" {
  default = "adwaitchangan.me."
}

variable "record_type" {
  default = "A"
}

variable "record_ttl" {
  default = 300
}

variable "vpc_connector_name" {
  default = "cf-vpc-connector"
}

variable "vpc_connector_range" {
  default = "10.8.0.0/28"
}

variable "topic_name" {
  default = "verify_email"
}

variable "service_ps_name" {
  default = "service-account-pubsub"
}

variable "service_ps_display" {
  default = "service-account-pubsub"
}

variable "cf_name" {
  default = "verify_email"
}

variable "cf_desc" {
  default = "My Cloud Function"
}

variable "cf_runtime" {
  default = "nodejs20"
}

variable "cf_entry_pt" {
  default = "helloPubSub"
}


variable "cf_bucket" {
  default = "csye6225-cloud-function-bucket"
}

variable "cf_bucket_file" {
  default = "serverless"
}

variable "mailgunkey" {
  default = "30b334475448b8389ba1f58b6890ea4f-f68a26c9-7c751faa"
}

variable "cf_memory" {
  default = "256M"
}

variable "cf_ttl" {
  default = 60
}

variable "cf_cpu" {
  default = 1
}

variable "cf_event" {
  default = "google.cloud.pubsub.topic.v1.messagePublished"
}

variable "cf_policy" {
  default = "RETRY_POLICY_RETRY"
}

variable "webapp_port1" {
}

variable "webapp_port2" {
}

variable "source_ranges" {
}

variable "vpcs" {
  default = {
    vpc-network1 = {
      name = "vpc-network1"
    },
    vpc-network2 = {
      name = "vpc-network2"
    },
    vpc-network3 = {
      name = "vpc-network3"
    }
  }
}

variable "subnet" {
  default = {
    subnet1 = {
      vpc  = "vpc-network1"
      name = "webapp"
      cidr = "10.1.0.0/24"
    },
    subnet2 = {
      vpc  = "vpc-network1"
      name = "db"
      cidr = "10.2.0.0/24"
    },
    subnet3 = {
      vpc  = "vpc-network2"
      name = "webapp-2"
      cidr = "10.3.0.0/24"
    },
    subnet4 = {
      vpc  = "vpc-network2"
      name = "db-2"
      cidr = "10.4.0.0/24"
    },
    subnet5 = {
      vpc  = "vpc-network3"
      name = "webapp-3"
      cidr = "10.5.0.0/24"
    },
    subnet6 = {
      vpc  = "vpc-network3"
      name = "db-3"
      cidr = "10.6.0.0/24"
    }
  }
}

variable "webapp_route" {
  default = {
    webapp_route = {
      name = "webapp-route",
      vpc  = "vpc-network1"
    },
    webapp_route1 = {
      name = "webapp-route1",
      vpc  = "vpc-network2"
    },
    webapp_route2 = {
      name = "webapp-route2",
      vpc  = "vpc-network3"
    }
  }
}

variable "on_host_maintenance_instance" {
  default = "MIGRATE"
}

variable "compute-health-check-name" {
  default = "compute-health-check"
}

variable "check_interval_sec_health_check" {
  default = 5
}

variable "timeout_sec_health_check" {
  default = 5
}

variable "healthy_threshold_health_check" {
  default = 2
}

variable "unhealthy_threshold_health_check" {
  default = 10
}

variable "https_health_check_port" {
  default = 3000
}

variable "https_health_check_request_path" {
  default = "/healthz"
}

variable "webapp_instance_region_group_manager_name" {
  default = "webapp-instance-region-group-manager"
}

variable "base-instance-name" {
  default = "webapp-instance"
}

variable "named_port_name" {
  default = "http"
}

variable "named_port_port" {
  default = 3000
}

variable "webapp_region_autoscaler_name" {
  default = "webapp-region-autoscaler"
}

variable "autoscaling_policy_max_replicas" {
  default = 6
}

variable "autoscaling_policy_min_replicas" {
  default = 3
}

variable "autoscaling_policy_cooldown_period" {
  default = 60
}

variable "cpu_utilization_target" {
  default = 0.05
}

variable "source_ranges1" {
  default = "130.211.0.0/22"
}

variable "source_ranges2" {
  default = "35.191.0.0/16"
}

variable "module_source" {
  default = "terraform-google-modules/lb-http/google"
}

variable "module_name" {
  default = "group-http-lb"
}

variable "target_tags" {
  default = "webapp"
}

variable "ssl_domain" {
  default = "adwaitchangan.me"
}

variable "sa_key_role" {
  default = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}

variable "vm_key" {
  default = "vm-key"
}

variable "key_rotation_period" {
  default = "2592000s"
}

variable "cloudsql_key" {
  default = "cloudsql-key"
}

variable "storage_key" {
  default = "storage-key"
}

variable "object_key" {
  default = "object-key"
}

variable "cloudsql_service_account_id" {
  default = "cloudsql-service-account"
}

variable "cloudsql_service_account_name" {
  default = "cloudsql_service_account"
}

variable "key_ring_service_account_id" {
  default = "key-ring-service-account"
}

variable "key_ring_service_account_name" {
  default = "key-ring-service-account"
}

variable "key_ring_iam_role" {
  default = "roles/cloudkms.admin"
}

variable "gcp_sa_cloud_sql_service" {
  default = "sqladmin.googleapis.com"
}

variable "bucket_name" {
  default = "csye6225-cloud-function-bucket"
}

variable "storage_class_bucket" {
  default = "STANDARD"
}

variable "storage_bucket_object_name" {
  default = "serverless"
}

variable "storage_bucket_object_source" {
  default = "./serverless.zip"
}