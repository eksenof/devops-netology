resource "local_file" "inventory" {
  content = <<-DOC
    


    [nle]
    eksen.space ansible_host=62.84.116.169 email=eksenof@goiba.net domain=eksen.space

    [monitoring]
    monitoring.eksen.space ansible_host=${yandex_compute_instance.vms4.network_interface.0.nat_ip_address} domain=eksen.space
 
    DOC

  filename = "../ansible/inventory.yml"

  depends_on = [
    yandex_compute_instance.vm,
    yandex_compute_instance.vms4,
  ]
}
