variable "enterprise_name" {
  description = "The name of your enterprise"
  type        = string
}

variable "enterprise_description" {
  description = "A description of your enterprise"
  type        = string
  default     = "Highest level organization in the company hierarchy."
}

variable "azure_tenant_id" {
  description = "The Azure tenant ID"
  type        = string
}
