terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.70.0"
    }
  }
}

provider "yandex" {
  access_key = var.access_key
  secret_key = var.secret_key
  cloud_id   = var.cloud_id
  folder_id  = var.folder_id
}

resource "yandex_vpc_network" "net" {
  name = "${var.project_prefix}-net"
}

resource "yandex_vpc_subnet" "subnet" {
  name       = "${var.project_prefix}-subnet"
  zone       = var.zone
  network_id = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.10.10.0/24"]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm" {
  name = "${var.project_prefix}-vm"

  resources {
    cores  = 2
    memory = 4
  }

  zone = var.zone

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 40
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.YC_PUBLIC_KEY}"
  }
}