variable "enterprise_name" {
  description = "The name of the highest level organization in the enterprise hierarchy."
  type        = string
  default     = "Big Kahuna"
}

variable "enterprise_description" {
  description = "The description of the highest level organization in the enterprise hierarchy."
  type        = string
  default     = "Big Kahuna owns all companies in the world."
}

variable "azure_tenant_id" {
  description = "The Azure tenant ID to use when deploying resources."
  type        = string
  sensitive   = true
}

variable "azure_sdlc_map" {
  description = <<EOT
    The Azure subscription ID map to use for
    various environments,
    applications, etc.
  EOT
  type        = map(object({
    subscription_id = string
    cidr_block      = string
  }))
  sensitive   = true

  validation  {
    condition = contains(keys(var.azure_subscription_ids), "development")
    error_message = "The map must contain at least the 'development' key."
  }
}

variable "azure_cidr_blocks" {
  description = <<EOT
    The CIDR Blocks to use for the SDLC environments in Azure.
  EOT
  type        = map(string)
  default = {
    "development" = "10.0.0.0/24",
    "production"  = "10.1.0.0/24",
    "shared"      = "10.2.0.0/24",
  }


  validation  {
    condition = contains(keys(var.azure_subscription_ids), "development")
    error_message = "The map must contain at least the 'development' key."
  }
}
