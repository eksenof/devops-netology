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
    access_key = "YCAJEXW7_V3HB1FFXANUVBtpL"
    secret_key = "YCPO0eHyMvcGFOimXU9qgf7KjmcbM6Rq_TQU-JRQ"

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

resource "yandex_dns_recordset" "rs0" {
  zone_id = yandex_dns_zone.eksen.id
  name = "@"
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.eksen.id
  name = "www.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs2" {
  zone_id = yandex_dns_zone.eksen.id
  name = "gitlab.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs3" {
  zone_id = yandex_dns_zone.eksen.id
  name = "grafana.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs4" {
  zone_id = yandex_dns_zone.eksen.id
  name = "prometheus.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}

resource "yandex_dns_recordset" "rs5" {
  zone_id = yandex_dns_zone.eksen.id
  name = "alertmanager.eksen.space."
  type = "A"
  ttl = 90
  data = [var.yc_public_ip]
}


#--- создание виртуальных машин ------------------------------------------------
#--- vm - основная машина 2Гб+2Гб nginx + EL------------------------------------------------

resource "yandex_compute_instance" "vm" {
  name     = "vm"
  zone     = "ru-central1-a"
  hostname = "vm.netology.cloud"

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

#image_id is free image ubintu-20.04-LTS from yandex.cloud marketplace
  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "disk"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }

}


#--- vms - 4 машинs 4Гб+4Гб  ----------------------------------------------------------

resource "yandex_compute_instance" "vms" {
  count    = 3
  name     = "vms${count.index}"
  zone     = "ru-central1-a"
  hostname = "vms${count.index}.netology.cloud"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = true
    ip_address = "192.168.1.1${count.index}"
  }

#image_id is free image ubintu-20.04-LTS from yandex.cloud marketplace
  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "disk${count.index}"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }

}


#----- vms - 1 машинa 4Гб+4Гб+10Гб -------------------------------------------------

resource "yandex_compute_instance" "vms3" {
  name     = "vms3"
  zone     = "ru-central1-a"
  hostname = "vms3.netology.cloud"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = true
    ip_address = "192.168.1.13"
  }

#image_id is free image ubintu-20.04-LTS from yandex.cloud marketplace
  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "disk3"
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

#------машина для раннера  ---------------------------------------------------

resource "yandex_compute_instance" "vms4" {
  name     = "vms4"
  zone     = "ru-central1-a"
  hostname = "vms4.netology.cloud"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = true
    ip_address = "192.168.1.14"
  }

#image_id is free image ubintu-20.04-LTS from yandex.cloud marketplace
  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "disk4"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }

}


#----- машина для мониторинга ----------------------------------------------------

resource "yandex_compute_instance" "vms5" {
  name     = "vms5"
  zone     = "ru-central1-a"
  hostname = "vms5.netology.cloud"

  resources {
    cores  = 4
    memory = 4
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet1.id
    nat        = true
    ip_address = "192.168.1.15"
  }

#image_id is free image ubintu-20.04-LTS from yandex.cloud marketplace
  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "disk5"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
     user-data = "${file("ssh-key")}"
  }

}
