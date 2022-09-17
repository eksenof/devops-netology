output "internal_ip_address" {
  value = "${yandex_compute_instance.nle.network_interface.0.ip_address}"
}

output "external_ip_address" {
  value = "${var.yc_public_ip}"
}

output "internal_ip_address0" {
  value = "${yandex_compute_instance.db01.network_interface.0.ip_address}"
}

output "external_ip_address0" {
  value = "${yandex_compute_instance.db01.network_interface.0.nat_ip_address}"
}

output "internal_ip_address1" {
  value = "${yandex_compute_instance.db02.network_interface.0.ip_address}"
}

output "external_ip_address1" {
  value = "${yandex_compute_instance.db02.network_interface.0.nat_ip_address}"
}

output "internal_ip_address2" {
  value = "${yandex_compute_instance.app.network_interface.0.ip_address}"
}

output "external_ip_address2" {
  value = "${yandex_compute_instance.app.network_interface.0.nat_ip_address}"
}


output "internal_ip_address3" {
  value = "${yandex_compute_instance.gitlab.network_interface.0.ip_address}"
}

output "external_ip_address3" {
  value = "${yandex_compute_instance.gitlab.network_interface.0.nat_ip_address}"
}


output "internal_ip_address4" {
  value = "${yandex_compute_instance.runner.network_interface.0.ip_address}"
}

output "external_ip_address4" {
  value = "${yandex_compute_instance.runner.network_interface.0.nat_ip_address}"
}


output "internal_ip_address5" {
  value = "${yandex_compute_instance.monitoring.network_interface.0.ip_address}"
}

output "external_ip_address5" {
  value = "${yandex_compute_instance.monitoring.network_interface.0.nat_ip_address}"
}
