locals {
  application = "docker"
  version     = "5.7.22-2"
}

variable "deployment_short_name" {
  description = "Name of the deployment, short way. (e.g. mydeployment)."
}

# Settings for authentication
variable "tenancy_ocid" {
  description = "OCID of the tenancy to be used."
}

variable "user_ocid" {
  description = "OCID of the user to be used."
}

variable "fingerprint" {
  description = "Fingerprint of the ssh deploy key to be used."
}

variable "private_key_path" {
  description = "Path to the private key which fingerprint is above."
}

variable "private_key_password" {
  description = "Password for the private key"
  default     = ""
}

# Location
variable "compartment_ocid" {
  description = "Ocid of the compartment to be used."
}

variable "region" {
  description = "Region to use."
}

variable "availability_domain" {
  description = "Availability domain to be used."
  default     = "1"
}

# Compute
variable "nodes_count" {
  description = "Number of instances to deploy. (Minimum recommended: 3)."
}

variable "instance_shape" {
  description = "Size of each instance. (Minimum recommended: VM.Standard1.1)."
}

variable "image_ocid" {
  description = "Image OCID to use. Default CentOS7 - Phoenix."
}

variable "volume_size" {
  description = "Size of the data volume in GBs. (Minimum recommended: 200)."
}

variable "username" {
  description = "Username inside the created instance."
}

locals {
  # Bootstrap script to be executed at init time
  bootstrap_file = "./userdata/bootstrap.sh"
}

variable "custom_userdata" {
  description = "Custom user-data to pass to the bootstrap script."
  default     = ""
}

variable "ssh_public_key_path" {
  description = "Path to the public key used on the instances."
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Path to the private key used on the instances."
  default     = "~/.ssh/id_rsa"
}
