# Configure the required providers
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.18.0"
    }
  }
}

# Configure the Google Cloud provider
provider "google" {
  credentials = "./keys/service-account.json"
  project     = "lexical-pattern-445923-p1"
  region      = "us-central1"
}

# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

# Define a Google Compute Instance resource
resource "google_compute_instance" "de-course-zoomcamp" {
  name         = "de-course-zoomcamp"
  machine_type = "e2-medium"
  zone         = "us-central1-c"

  # Configure the boot disk
  boot_disk {
    auto_delete = true
    device_name = "de-course-zoomcamp"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250111"
      size  = 15
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  # Add labels to the instance
  labels = {
    goog-ec-src = "vm_add-tf"
  }

  # Startup script to install and start Docker, and clone the repository
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io git
    systemctl start docker
    systemctl enable docker
    git clone https://github.com/Halum/data-engineering-course /home/de/data-engineering-course
  EOT

  # Configure the network interface
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/lexical-pattern-445923-p1/regions/us-central1/subnetworks/default"
  }

  # Configure the scheduling options
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  # Configure the shielded instance options
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }
}
