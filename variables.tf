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

variable "azure_subscription_ids" {
  description = "The Azure subscription ID map to use for various environments, applications, etc."
  type        = map(string)
  sensitive   = true

  validation  {
    condition = contains(keys(var.azure_subscription_ids), "development")
    error_message = "The map must contain at least the 'development' key."
  }
}
