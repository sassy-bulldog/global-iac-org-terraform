resource "spacelift_azure_integration" "enterprise" {
  name                    = var.enterprise_name
  space_id                = spacelift_space.enterprise.id
  tenant_id               = var.azure_tenant_id
  default_subscription_id = var.azure_subscription_ids["development"]
  
  labels    = setunion(
    local.labels,
    [
      "autoattach:azure",
    ]
  )
}

# For a stack to talk to Azure, you need to attach an Azure integration to it.
resource "spacelift_azure_integration_attachment" "sdlc_environments" {
  for_each = spacelift_stack.sdlc_environments

  integration_id  = spacelift_azure_integration.enterprise.id
  stack_id        = each.value.id
  write           = true
  subscription_id = var.azure_subscription_ids[each.key]
}
