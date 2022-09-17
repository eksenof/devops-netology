terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "eks-bucket"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id  = "b1g8tmicdilcfj3v86od"
  folder_id = "b1gr8f7jc2bibcivq2vb"
  zone      = "ru-central1-a"
  service_account_key_file = "key.json"
}


#--- создание сетей и подсетей ------------------------------------------------

resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}


#--- создание записей dns ------------------------------------------------------

resource "yandex_dns_zone" "eksen" {
  name = "eksen"
  zone = "eksen.space."
  public = true
}

resource "yandex_dns_recordset" "rs9" {
  zone_id = yandex_dns_zone.eksen.id
  name = "@"
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs10" {
  zone_id = yandex_dns_zone.eksen.id
  name = "www.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs11" {
  zone_id = yandex_dns_zone.eksen.id
  name = "gitlab.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs12" {
  zone_id = yandex_dns_zone.eksen.id
  name = "grafana.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs13" {
  zone_id = yandex_dns_zone.eksen.id
  name = "prometheus.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs14" {
  zone_id = yandex_dns_zone.eksen.id
  name = "alertmanager.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}


#--- создание виртуальных машин -----------------------------------------------
#--- nle - основная машина 2Гб+2я nginx + LetsEncrypt--------------------------

resource "yandex_compute_instance" "nle" {
  name     = "nle"
  zone     = "ru-central1-a"
  hostname = "nle.eksen.space"

  resources {
    cores  = 2
    memory = 2
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat = true
    ip_address = "192.168.1.9"
    nat_ip_address = var.yc_public_ip
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image
      name     = "disk9"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }
}

#--- dbo01, db02, app - машины для MySQL и Wordpress 4Гб+4я  ------------------

resource "yandex_compute_instance" "db01" {
  name     = "db01"
  zone     = "ru-central1-a"
  hostname = "db01.eksen.space"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = false
    ip_address = "192.168.1.10"
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image
      name     = "disk10"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }
}

resource "yandex_compute_instance" "db02" {
  name     = "db02"
  zone     = "ru-central1-a"
  hostname = "db02.eksen.space"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = false
    ip_address = "192.168.1.11"
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image
      name     = "disk11"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }
}

resource "yandex_compute_instance" "app" {
  name     = "app"
  zone     = "ru-central1-a"
  hostname = "app.eksen.space"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = false
    ip_address = "192.168.1.12"
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image
      name     = "disk12"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }
}


#----- gitlab - машинa для гитлаб с увеличенным диском 4Гб+4я+10Гб -----------

resource "yandex_compute_instance" "gitlab" {
  name     = "gitlab"
  zone     = "ru-central1-a"
  hostname = "gitlab.eksen.space"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = false
    ip_address = "192.168.1.13"
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image
      name     = "disk13"
      size     = 10
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }
}


#------ runner - машина для раннера 4Гб+4я -----------------------------------

resource "yandex_compute_instance" "runner" {
  name     = "runner"
  zone     = "ru-central1-a"
  hostname = "runner.eksen.space"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = false
    ip_address = "192.168.1.14"
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image
      name     = "disk14"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }

}

#----- машина для мониторинга ------------------------------------------------

resource "yandex_compute_instance" "monitoring" {
  name     = "monitoring"
  zone     = "ru-central1-a"
  hostname = "monitoring.eksen.space"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = false
    ip_address = "192.168.1.15"
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image
      name     = "disk15"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }
}
