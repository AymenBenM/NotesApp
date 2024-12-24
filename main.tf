terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Create CloudInit disk with SSH key and user data
resource "libvirt_cloudinit_disk" "ubuntu_cloudinit" {
  name = "ubuntu-cloudinit.iso"
  
  user_data = <<-EOT
    #cloud-config
    # Update package lists on first boot
    package_update: true
    package_upgrade: true

    # Create user with sudo privileges
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC74wGkhQtobP/b4sV/CvH5n1SObnB/GYvQ4MAD/RYnrKSrj89I6LDfnynjjuU+YgJBFnmhuNOu7x8TIaEmc/PqjXUggkyZ9jtiKDbj4JFcxcX770/AfVz7rc82g5gcoi9eH0uQ/7AlCRSEZMJ21J2IYyXp1ywpc+qnEGKQxI5c9miJqD6OqOMivzBBbUHUT+QifFXJ5VZ5r533RK/4ViMk7yWhSLQ6aK3Gq5EnleS2JFUPzTdgsoM9MzvG7XHR4Uwi3uVdpiMFc3YARxCO2S"

    # Configure SSH
    ssh_pwauth: false
    disable_root: true

    # Set timezone
    timezone: UTC

    # Install some basic packages
    packages:
      - curl
      - vim
      - wget
  EOT
}