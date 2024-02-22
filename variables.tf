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