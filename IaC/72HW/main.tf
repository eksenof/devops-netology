terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

#Add your token number
provider "yandex" {
  token     = ""
  cloud_id  = "b1g8tmicdilcfj3v86od"
  folder_id = "b1gr8f7jc2bibcivq2vb"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm" {
  name     = "vm-ubuntu20.04"
  zone     = "ru-central1-a"
  hostname = "vm.netology.cloud" 

  resources {
    cores  = 2
    memory = 2
  }

#image_id is free image ubintu-20.04-LTS from yandex.cloud marketplace 
  boot_disk {
    initialize_params {
      image_id = "fd8ofg98ci78v262j491"
      name     = "ubuntu-disk"
    }
  }

#add subnetwork id after creating it
  network_interface {
    subnet_id = ""
    nat       = true
  }
}

resource "yandex_vpc_network" "default" {
  name = "net"
}


#add network_id after creating it
resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone = "ru-central1-a"
  network_id = ""
  v4_cidr_blocks = ["192.168.101.0/24"]
}
