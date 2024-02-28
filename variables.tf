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
  default = "n1-standard-1"
}

variable "deny_port" {
  default = 22
}

variable "app_tag" {
  default = "webapp"
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
  default = 100
}

variable "instance_type" {
  default = "pd-balanced"
}

variable "instance_family" {
  default = "custom-family"
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