# Author: Daniel Vanderloo <marss6414@gmail.com>



# Output

output "vm_name" {
    value = "${var.instance_name}-${local.env_code}-${random_string.random.result}"
}

output "private_ip_address" {
    value = google_compute_instance.default.network_interface.0.network_ip
}

output "public_ip_address" {
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

output "root_password" {
    value = random_password.password.result
	sensitive = true
}