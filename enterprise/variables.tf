variable "create" {
  description = <<EOT
  (Required) Whether to create specific common resources.
  Supported resources are:
  - vpn
  - backups
  EOT
  type = object({
    vpn     = bool
    data_lake = bool
    backups = bool
  })
  default = {
    vpn     = false
    data_lake = true
    backups = false
  }
}

variable "company_name" {
  description = "Name of the company in the enterprise hierarchy that owns the resources."
  
}

variable "resource_group" {
  description = "The subcategory or purpose for billing allocations."
  type        = string
  default     = "Enterprise"
}

variable "azure_region" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "South Central US"
}

# https://en.wikipedia.org/wiki/Reserved_IP_addresses
variable "azure_vnet_cidr_block" {
  description = "The CIDR block for the Azure VNet"
  type        = string
  default     = "10.0.0.0/8"
}
