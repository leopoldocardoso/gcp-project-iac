resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = data.google_compute_network.vpc_gke.name
  region  = var.region
}



resource "google_compute_router_nat" "nat_gke" {
  name                               = "nat-gke"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"



}

resource "google_compute_firewall" "allow_egress" {
  name      = "allow-egress"
  network   = data.google_compute_network.vpc_gke.name
  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  allow {
    protocol = "udp"
  }
  destination_ranges = ["0.0.0.0/0"]

  description = "Created by Terraform"

  depends_on = [google_compute_router_nat.nat_gke]
}

