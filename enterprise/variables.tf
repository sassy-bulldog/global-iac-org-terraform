variable "create" {
  description = <<EOT
  (Required) Whether to create specific common resources.
  Supported resources are:
  - vpn
  - backups
  EOT
  type = object({
    vpn     = bool
    backups = bool
  })
  default = {
    vpn     = false
    backups = false
  }
}

variable "company_name" {
  description = "The name of your company"
  type        = string
  default     = "Enterprise"
}

variable "azure_region" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "South Central US"
}
