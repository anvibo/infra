resource "random_string" "password" {
  length = 16
  special = true
}

resource "google_container_cluster" "cluster10" {
    name = "cluster10"
    zone = "europe-west4-a"
    remove_default_node_pool = true
    initial_node_count = 1
    network = "vpc-1"
    subnetwork = "vpc-1-eu-west4-1"

    master_auth {
        username = "admin"
        password = "${random_string.password.result}"
    }
}

resource "google_container_node_pool" "micro_1" {
  name       = "micro-1"
  region     = "europe-west4-a"
  cluster    = "${google_container_cluster.cluster10.name}"
  
  initial_node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }
  management {
    auto_repair = true
  }

 

  node_config {
    preemptible  = false
    machine_type = "f1-micro"
    disk_type = "pd-standard"
    disk_size_gb = "10"
    tags = ["http-server", "https-server"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/sqlservice.admin",
    ]

     labels = {
      size = "micro"
      type = "stable"
    }
  }
}

resource "google_container_node_pool" "small_2_prem" {
  name       = "small-2-prem"
  region     = "europe-west4-a"
  cluster    = "${google_container_cluster.cluster10.name}"
  
  initial_node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }
  management {
    auto_repair = true
  }

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_type = "pd-standard"
    disk_size_gb = "10"
    tags = ["http-server", "https-server"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/sqlservice.admin",

    ]

    labels = {
      size = "small"
      type = "prem"
    }
  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.
output "client_certificate" {
  value = "${google_container_cluster.cluster10.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.cluster10.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.cluster10.master_auth.0.cluster_ca_certificate}"
}

output "endpoint" {
  value = "${google_container_cluster.cluster10.endpoint}"
}
