resource "spacelift_azure_integration" "enterprise" {
  name      = var.enterprise_name
  space_id  = spacelift_space.enterprise.id
  tenant_id = var.azure_tenant_id
  labels    = [var.enterprise_name]
}