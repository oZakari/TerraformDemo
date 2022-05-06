variable "environment_prefix" {
  default     = "poc"
  description = "Prefix of the environment resource names."
  type        = string
}

variable "region" {
  default     = "centralus"
  description = "The region where the resources are deployed to."
  type        = string
}

variable "vm_size" {
  default     = "Standard_D2s_v5"
  description = "The size of the virtual machine."
  type        = string
}

variable "computer_name" {
  default     = "windows-server-poc"
  description = "The host name of the computer."
  type        = string
}

variable "admin_username" {
  default     = "adminusername"
  description = "The username for the admin account used to access the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The password for the admin account used to access the virtual machine."
  type        = string
  sensitive   = true
}
