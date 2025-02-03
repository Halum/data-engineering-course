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

# Reserve a static IP address
resource "google_compute_address" "static_ip" {
  name   = "de-course-zoomcamp-static-ip"
  region = "us-central1"
}

# Define a Google Compute Instance resource
resource "google_compute_instance" "de-course-zoomcamp" {
  name         = "de-course-zoomcamp"
  machine_type = "e2-standard-2"
  zone         = "us-central1-c"

  # Configure the boot disk
  boot_disk {
    auto_delete = true
    device_name = "de-course-zoomcamp-disk"

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
    # Update and upgrade the system
    apt-get update
    apt-get upgrade -y

    # Create a development user
    DEV_USER=de
    REPO_NAME=data-engineering-course

    # Install Docker and Git
    apt-get install -y docker.io git
    
    # Add the development user to the Docker group
    usermod -aG docker $DEV_USER
    
    # Install Docker Compose
    DOCKER_CONFIG=/usr/local/lib/docker
    mkdir -p $DOCKER_CONFIG/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
    
    # Start the Docker service and enable it to start on boot
    systemctl start docker
    systemctl enable docker
    
    # Clone the data engineering course repository
    git clone https://github.com/Halum/data-engineering-course /home/$DEV_USER/$REPO_NAME
    git config --global --add safe.directory /home/$DEV_USER/$REPO_NAME
    git config --global user.name "Sajjad Hossain"
    git config --global user.email "my.lost.word@gmail.com"

    # Change ownership and permission of the pg_admin_data directory
    chown -R $DEV_USER:$DEV_USER /home/$DEV_USER
    chmod -R 775 /home/$DEV_USER
    
    # Change ownership and permission of the pg_admin_data directory
    chown -R 5050:5050 /home/$DEV_USER/$REPO_NAME/data/pg_admin_data
    chmod -R 775 /home/$DEV_USER/$REPO_NAME/data/pg_admin_data
  EOT

  # Configure the network interface
  network_interface {
    access_config {
      nat_ip       = google_compute_address.static_ip.address
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
