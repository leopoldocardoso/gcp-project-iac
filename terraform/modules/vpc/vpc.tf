resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = var.vpc.name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"

}

resource "google_compute_subnetwork" "subnet_vms_vpc_project_gcp" {
  name          = var.vpc.subnets[0].name
  project       = var.project_id
  region        = var.vpc.subnets[0].region
  ip_cidr_range = var.vpc.subnets[0].ip_cidr_range
  network       = google_compute_network.this.id

  private_ip_google_access = true

  depends_on = [google_compute_network.this]
}

resource "google_compute_subnetwork" "subnet_gke_project_gcp" {
  name          = var.vpc.subnets[1].name
  project       = var.project_id
  region        = var.vpc.subnets[1].region
  ip_cidr_range = var.vpc.subnets[1].ip_cidr_range
  network       = google_compute_network.this.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods-range" # Nome que deve coincidir com var.pods_range_name
    ip_cidr_range = "10.1.0.0/16"    # CIDR para pods
  }

  secondary_ip_range {
    range_name    = "gke-services-range" # Nome que deve coincidir com var.services_range_name
    ip_cidr_range = "10.2.0.0/16"        # CIDR para services
  }

  depends_on = [google_compute_network.this]
}


