# Author: Daniel Vanderloo <marss6414@gmail.com>


variable "instance_name" {
	type        = string
	default     = "db-srv001"
}


variable "environment" {
	type        = string
	default     = "production"
}


variable "region" {
	type        = string
	default     = ""
}


variable "zone" {
	type        = string
	default     = "us-west1-a"
}


variable "machine_type" {
	type        = string
	default     = "e2-micro"
}


variable "network_id" {
	type        = string
	default     = "network-prod"
}


variable "public_ip" {
	type        = bool
	default     = false
}


variable "labels" {
	type = map
    default = {
        "label1" = "value1"
        "label2" = "value2"
    }
}


variable "root_username" {
	type        = string
	default     = "root2"
}


variable "credentials" {
	type        = string
	default     = "gcp_service_file.json"
}



# The "env_code” string must be parsed from the environment variable using a Terraform function inside the module.
# ex: env_code: p

locals {
	env_code = substr(var.environment, 0, 1)
}





