variable "location" {
  type        = string
  default     = "East US"
  description = "Azure Region"
}

variable "resource_group_name" {
  type        = string
  default     = "vm-demo-rg"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Admin password"
  sensitive   = true
}