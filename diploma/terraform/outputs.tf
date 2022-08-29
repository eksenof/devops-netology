output "internal_ip_address" {
  value = "${yandex_compute_instance.vm.network_interface.0.ip_address}"
}

output "external_ip_address" {
  value = var.yc_public_ip
}


output "internal_ip_address0" {
  value = "${yandex_compute_instance.vms[0].network_interface.0.ip_address}"
}

output "external_ip_address0" {
  value = "${yandex_compute_instance.vms[0].network_interface.0.nat_ip_address}"
}

output "internal_ip_address1" {
  value = "${yandex_compute_instance.vms[1].network_interface.0.ip_address}"
}

output "external_ip_address1" {
  value = "${yandex_compute_instance.vms[1].network_interface.0.nat_ip_address}"
}


output "internal_ip_address2" {
  value = "${yandex_compute_instance.vms[2].network_interface.0.ip_address}"
}

output "external_ip_address2" {
  value = "${yandex_compute_instance.vms[2].network_interface.0.nat_ip_address}"
}


output "internal_ip_address3" {
  value = "${yandex_compute_instance.vms3.network_interface.0.ip_address}"
}

output "external_ip_address3" {
  value = "${yandex_compute_instance.vms3.network_interface.0.nat_ip_address}"
}


output "internal_ip_address4" {
  value = "${yandex_compute_instance.vms4.network_interface.0.ip_address}"
}

output "external_ip_address4" {
  value = "${yandex_compute_instance.vms4.network_interface.0.nat_ip_address}"
}

output "internal_ip_address5" {
  value = "${yandex_compute_instance.vms5.network_interface.0.ip_address}"
}

output "external_ip_address5" {
  value = "${yandex_compute_instance.vms5.network_interface.0.nat_ip_address}"
}
