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

variable "default_azure_subscription_id" {
  description = "The default Azure subscription ID when deploying resources."
  type        = string
  sensitive   = true
}
