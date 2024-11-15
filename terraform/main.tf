# Create a separate VPC
resource "google_compute_network" "custom_vpc" {
  name = "test-vpc"
}

# Create a VM instance with a public IP and SSH keys
resource "google_compute_instance" "vm_instance" {
  name         = "my-vm-instance"
  machine_type = "e2-small"
  zone         = "europe-west3-a"
  tags         = ["webapp"]
  labels = {
    app = "webapp"
  }
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    network       = google_compute_network.custom_vpc.name
    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo useradd -m webappuser
    sudo mkdir -p /home/webappuser/.ssh
    echo "${var.ssh_key}" >> /home/webappuser/.ssh/authorized_keys
    sudo chmod 700 /home/webappuser/.ssh
    sudo chmod 600 /home/webappuser/.ssh/authorized_keys
    sudo chown -R webappuser:webappuser /home/webappuser/.ssh
    echo "webappuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  EOT

  metadata = {
    ssh-keys = "webappuser:${var.ssh_key}"
  }
}

# Firewall rule to allow HTTP access
resource "google_compute_firewall" "http_access" {
  name    = "allow-http"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22","80","8080","9000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["webapp"]
}
variable "ssh_key" {
}
variable "vm_image" {
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}
output "instance_ip" {
    value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
