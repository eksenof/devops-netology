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
# Add your credentials
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

#Add your token number, cloud_id, folder_id
provider "yandex" {
  token     = ""
  cloud_id  = ""
  folder_id = ""
  zone      = "ru-central1-a"
}


resource "yandex_vpc_network" "net" {
  name = "net"
}


resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

#-----------------------------------------------------------------------
locals {
  instance_OS = {
# Images from Yandex.Cloud Market - Ubuntu20 and Ubuntu16
    stage = "fd8ofg98ci78v262j491"
    prod = "fd8177ttrp7i4qqc75d6"
  }

  instance_count = {
    stage = 1
    prod = 2
  }
  
  instances = {
    vm1 = 1
    vm2 = 2
  }
}

#-----------------------------------------------------------------------
resource "yandex_compute_instance" "vm-count" {
  name     = "vm-${count.index}-${terraform.workspace}"
  zone     = "ru-central1-a"
  hostname = "vm.netology.cloud-${count.index}-${terraform.workspace}"

  count = local.instance_count[terraform.workspace]

  resources {
    cores  = 2
    memory = 2
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  boot_disk {
    initialize_params {
      image_id = local.instance_OS[terraform.workspace]
      name     = "disk-${count.index}-${terraform.workspace}"
    }
  }
}

#--------------------------------------------------------------------------
resource "yandex_compute_instance" "vmt" {
  for_each = local.instances
  name     = "vm-${each.key}"
  zone     = "ru-central1-a"
  hostname = "vm.netology.cloud-${each.key}"

  resources {
    cores  = 2
    memory = 2
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "disk-${each.key}"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}
