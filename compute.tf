resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  zone        = var.zones[count.index]
  platform_id = "standard-v3"

  resources {
    cores  = var.vm_cpu
    memory = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = count.index == 0 ? yandex_vpc_subnet.subnet_a.id : yandex_vpc_subnet.subnet_b.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_ed25519.pub")}"

    user-data = <<-EOF
    #cloud-config
    package_update: true
    packages:
      - nginx
    runcmd:
      - systemctl enable --now nginx
      - echo "<h1>Server ${count.index + 1} - $(hostname)</h1>" > /var/www/html/index.html
  EOF
  }

}