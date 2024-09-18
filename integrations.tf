resource "spacelift_azure_integration" "enterprise" {
  name                    = var.enterprise_name
  space_id                = spacelift_space.enterprise.id
  tenant_id               = var.azure_tenant_id
  default_subscription_id = var.default_azure_subscription_id
  
  labels    = [var.enterprise_name]
}

# For a stack to talk to Azure, you need to attach an Azure integration to it.
resource "spacelift_azure_integration_attachment" "readonly" {
  integration_id  = spacelift_azure_integration.enterprise.id
  stack_id        = spacelift_stack.enterprise.id
  write           = false
  subscription_id = spacelift_azure_integration.enterprise.default_subscription_id
}
