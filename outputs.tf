# output "ApplicationPassword" {
#   value     = "${local.app_password}"
#   sensitive = true
# }

output "InstanceNames" {
  value = ["${oci_core_instance.instance.*.display_name}"]
}

output "PrivateIPs" {
  value = ["${oci_core_instance.instance.*.private_ip}"]
}

# Outputs
output "PublicIPs" {
  value = ["${oci_core_instance.instance.*.public_ip}"]
}
