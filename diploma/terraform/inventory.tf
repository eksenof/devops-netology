resource "local_file" "inventory" {
  content = <<-DOC


    [nle]
    eksen.space ansible_host=62.84.116.169 email=eksenof@goiba.net domain=eksen.space

    [db01]
    db01.eksen.space ansible_host=${yandex_compute_instance.vms[0].network_interface.0.nat_ip_address} domain=eksen.space mysql_server_id=1 mysql_replication_role=master
 
    [db02]
    db02.eksen.space ansible_host=${yandex_compute_instance.vms[1].network_interface.0.nat_ip_address} domain=eksen.space mysql_server_id=2 mysql_replication_role=slave
    
    [wordpress]
    app.eksen.space ansible_host=${yandex_compute_instance.vms[2].network_interface.0.nat_ip_address} domain=eksen.space 
    
    [gitlab]
    gitlab.eksen.space ansible_host=${yandex_compute_instance.vms3.network_interface.0.nat_ip_address} domain=eksen.space gitlab_external_url=http://gitlab.eksen.space/

    [monitoring]
    monitoring.eksen.space ansible_host=${yandex_compute_instance.vms4.network_interface.0.nat_ip_address} domain=eksen.space

    [runner]
    runner.eksen.space ansible_host=${yandex_compute_instance.vms5.network_interface.0.nat_ip_address} domain=eksen.space  
 
    DOC

  filename = "../ansible/inventory.yml"

  depends_on = [
    yandex_compute_instance.vm,
    yandex_compute_instance.vms[0],
    yandex_compute_instance.vms[1],
    yandex_compute_instance.vms[2],
    yandex_compute_instance.vms3,
    yandex_compute_instance.vms4,
    yandex_compute_instance.vms5,
  ]
}
