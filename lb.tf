resource "yandex_lb_target_group" "web_tg" {
  name      = "web-tg"
  region_id = "ru-central1"

  dynamic "target" {
    for_each = yandex_compute_instance.web[*]
    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "web_lb" {
  name = "web-lb"

  listener {
    name = "http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

#output "load_balancer_ip" {
#  value = tolist(
#    yandex_lb_network_load_balancer.web_lb.listener
#  )[0].external_address_spec[0].address
#}

output "web_instance_ips" {
  value = yandex_compute_instance.web[*].network_interface[0].nat_ip_address
}
