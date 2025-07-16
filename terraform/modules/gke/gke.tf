# Habilitar API do Container (GKE)
resource "google_project_service" "container_api" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# Habilitar API do Cloud Resource Manager
resource "google_project_service" "cloudresourcemanager_api" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "cluster_gke" {
  name                     = var.cluster_name
  location                 = var.cluster_zone
  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = data.google_compute_network.vpc_gke.name
  subnetwork               = data.google_compute_subnetwork.subnet_gke.name
  release_channel {
    channel = "UNSPECIFIED" # Desativa o auto upgrade do cluster
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  depends_on = [google_project_service.container_api, google_project_service.cloudresourcemanager_api]

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block = cidr_blocks.value
      }
    }
  }

  lifecycle {
    ignore_changes = [
      node_pool,
      initial_node_count,
    ]
  }
}

# Node pools dev e prod
resource "google_container_node_pool" "dev_node_pool" {
  name               = "dev-node-pool"
  location           = var.cluster_zone
  cluster            = google_container_cluster.cluster_gke.name
  initial_node_count = 1

  autoscaling {
    min_node_count = 1 # replicação para todas as zonas multiplicado por 3
    max_node_count = 1 # replicação para todas as zonas multiplicado por 3
  }

  management {
    auto_upgrade = false # desativa o auto ugprade do node
    auto_repair  = false
  }

  node_config {
    machine_type = var.machine_type_node_dev
    disk_size_gb = 50
    #disk_type    = "pd-standard"  # Usar disco padrão em vez de SSD
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      env = "dev"
    }

    tags = ["gke-node-dev"]
  }
}

resource "google_container_node_pool" "prod_node_pool" {
  name               = "prod-node-pool"
  location           = var.cluster_zone
  cluster            = google_container_cluster.cluster_gke.name
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  management {
    auto_upgrade = false # desativa o auto ugprade do node
    auto_repair  = false
  }

  node_config {
    machine_type = var.machine_type_node_prod
    disk_size_gb = 50 # Reduzir de 100GB para 50GB
    #disk_type    = "pd-standard"  # Usar disco padrão em vez de SSD
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      node_group = "prod"
      env        = "prod"
    }

    tags = ["gke-node-prod"]
  }

  depends_on = [google_container_cluster.cluster_gke]

}
