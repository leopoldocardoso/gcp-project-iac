resource "google_compute_instance" "vm_vpn" {
  name                      = var.vm_name
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  tags                      = ["vm-vpn"]

  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image,
      metadata_startup_script,
    ]
  }

  boot_disk {
    initialize_params {
      image = var.image_instance
      size  = 30
      type  = "pd-balanced" # equivalente a gp3 na aws
    }
    auto_delete = false
  }

  network_interface {
    network    = data.google_compute_network.vpc_vms.name
    subnetwork = data.google_compute_subnetwork.subnet_vms.name

    access_config {
      # Necessário se quiser IP público; remova se for só IP privado
    }
  }

  labels = {
    terraform = "true"
  }

}
