variable "location" {
  default = "UK South"
}

variable "resource_group_name" {
  default = "learning"
}


variable "username" {
  default = "learning"
  
}

variable "password" {
  default = "Redhat@12345"
  
}

variable "dns_prefix" {
  default = "aksdemo"
}

variable "node_count" {
  default = 2
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
  
  
}