variable "resource_group_name" {
  type        = string
  default     = "vm-sec-automation-rg"
  description = "Name of the Azure resource group"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Azure location for deployment"
}
