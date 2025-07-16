resource "google_compute_firewall" "vpn_allow_ssh" {
  name    = "allow-ssh"
  network = data.google_compute_network.vpc_vms.id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["179.235.186.249/32","0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-access", "vm-vpn"]
  depends_on  = [data.google_compute_network.vpc_vms]
}

resource "google_compute_firewall" "vpn_allow_icmp" {
  name    = "allow-icmp"
  network = data.google_compute_network.vpc_vms.id
  direction     = "INGRESS"
  priority      = 1001
  source_ranges = ["179.235.186.249/32"]
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_http_https_vpn" {
  name    = "allow-http-https-vpn"
  network = data.google_compute_network.vpc_vms.id
  direction     = "INGRESS"
  priority      = 1002
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = [ "vm-vpn" ]
}

resource "google_compute_firewall" "allow_pritunl" {
  name    = "allow-pritunl"
  network = data.google_compute_network.vpc_vms.id
  direction     = "INGRESS"
  priority      = 1003
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "udp"
    ports    = ["10193"]
  }
  target_tags = [ "vm-vpn" ]
}
