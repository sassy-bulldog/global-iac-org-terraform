resource "spacelift_space" "enterprise" {
  name        = var.enterprise_name
  description = var.enterprise_description

  # Every account has a root space that serves as the root for the space tree.
  # Except for the root space, all the other spaces must define their parents.
  parent_space_id  = "root"
  inherit_entities = false
  labels      = local.labels
}
