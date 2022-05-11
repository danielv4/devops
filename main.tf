# Author: Daniel Vanderloo <marss6414@gmail.com>


# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
# sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# sudo apt update
# sudo apt install terraform


# Init to add the necessary plugins
# terraform init


# Verifies that the syntax of main.tf
# terraform plan


# To create the VM, run terraform apply
# terraform apply


# List
# terraform state list


# Vars
# terraform apply -var="credentials=gcp_service_file.json" -var="instance_name=db" -var="zone=us-west1-a"


# Update deps
# terraform init -upgrade





resource "random_password" "password" {
	length           = 16
	special          = false
}


resource "random_string" "random" {
	length           = 16
	special          = false
	upper            = false
}



# generate keys
resource "tls_private_key" "ssh-key" {
	algorithm = "RSA"
	rsa_bits  = 4096
}


resource "local_file" "ssh_private" {
	content         = tls_private_key.ssh-key.private_key_pem
	filename        = "server.key"
	file_permission = "0600"
}


resource "local_file" "ssh_public" {
	content         = tls_private_key.ssh-key.public_key_openssh
	filename        = "server.pub"
	file_permission = "0600"
}








# Auth
provider "google" {
	project = "voxel-345723"
	region  = "us-central1"
	zone    = "us-central1-c"
	credentials = var.credentials
}



# Create a single Compute Engine instance
resource "google_compute_instance" "default" {

	# same format <instance_name>-<env_code>-<random_string>, example: db-srv001-p-dg64
	name         = "${var.instance_name}-${local.env_code}-${random_string.random.result}"
	
	machine_type = var.machine_type
	zone         = var.zone
	tags         = ["ssh"]


	metadata = {
		ssh-keys       = "provisioner:${tls_private_key.ssh-key.public_key_openssh}"
		enable-oslogin = "true"
	}


	boot_disk {
		initialize_params {
			image = "ubuntu-minimal-1804-lts"
			type  = "pd-ssd"
			size  = "10"
		}
	}


	# allow root from remote-exec
	metadata_startup_script = "useradd --create-home --shell /bin/bash provisioner && mkdir --mode 0700 /home/provisioner/.ssh && echo \"${tls_private_key.ssh-key.public_key_openssh}\" > /home/provisioner/.ssh/authorized_keys && chown -R provisioner: /home/provisioner && echo \"provisioner ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/provisioner"
	
	
	network_interface {
		network = "default"

		access_config {
			# Include this section to give the VM an external IP address
		}
	}
	
	
	
	# Using remote exec, sets a unique random password to the root user on the VM instance.
	provisioner "remote-exec" {
	
		connection {
			host  = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
			type  = "ssh"
			port  = 22
			user  = "provisioner"
			agent = "false"
			private_key = "${tls_private_key.ssh-key.private_key_pem}"
		}

		inline = [
			"echo \"root:${random_password.password.result}\" | sudo chpasswd",
		]
	}
}




# Save to a local file

resource "local_sensitive_file" "config" {
	filename = "config.txt"
	content = <<-EOT
		vm_name: "${var.instance_name}-${local.env_code}-${random_string.random.result}"
		private_ip_address: ${google_compute_instance.default.network_interface.0.network_ip}
		public_ip_address: ${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}
		root_password: ${random_password.password.result}
	EOT
}