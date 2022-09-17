resource "local_file" "inventory" {
  content = <<-DOC


    [nle]
    eksen.space ansible_host=62.84.116.169 email=evgeniia.ksenofontova@iba-group.com domain=eksen.space

    [db01]
    db01.eksen.space ansible_host=192.168.1.10 domain=eksen.space mysql_server_id=1 mysql_replication_role=master
    
    [db02]
    db02.eksen.space ansible_host=192.168.1.11 domain=eksen.space mysql_server_id=2 mysql_replication_role=slave
    
    [wordpress]
    app.eksen.space ansible_host=192.168.1.12 domain=eksen.space 
    
    [gitlab]
    gitlab.eksen.space ansible_host=192.168.1.13 domain=eksen.space gitlab_external_url=http://gitlab.eksen.space/

    [runner]
    runner.eksen.space ansible_host=192.168.1.14 domain=eksen.space

    [monitoring]
    monitoring.eksen.space ansible_host=192.168.1.15 domain=eksen.space
 

    DOC

  filename = "../ansible/inventory.yml"

  depends_on = [
    yandex_compute_instance.nle,
    yandex_compute_instance.db01,
    yandex_compute_instance.db02,
    yandex_compute_instance.app,
    yandex_compute_instance.gitlab,
    yandex_compute_instance.runner,
    yandex_compute_instance.monitoring,
  ]
}
