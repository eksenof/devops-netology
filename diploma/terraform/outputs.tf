output "internal_ip_address" {
  value = "${yandex_compute_instance.vm.network_interface.0.ip_address}"
}

output "external_ip_address" {
  value = var.yc_public_ip
}
 
output "internal_ip_address4" {
  value = "${yandex_compute_instance.vms4.network_interface.0.ip_address}"
}

output "external_ip_address4" {
  value = "${yandex_compute_instance.vms4.network_interface.0.nat_ip_address}"
}
