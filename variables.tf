variable "cloud_id" { type = string }
variable "folder_id" { type = string }

variable "zones" {
  default = ["ru-central1-a", "ru-central1-b"]
}

variable "subnet_cidrs" {
  default = ["192.168.10.0/24", "192.168.20.0/24"]
}

variable "vm_cpu" { default = 2 }
variable "vm_memory" { default = 2 }

variable "vm_image_id" {
  default = "fd85f16aij1rvpce9gas"
}

variable "allowed_ssh_ip" {
  default = "0.0.0.0/0"
}

variable "ssh_public_key" { type = string }
