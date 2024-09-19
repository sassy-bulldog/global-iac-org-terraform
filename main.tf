locals {
  sdlc_environments = toset([for env in keys(var.azure_sdlc_map): nonsensitive(env)])

  # Common labels or tags for all resources created by this module
  labels = [
    "Created-By:Spacelift",
    "Managed-By:Terraform",
    "Repository:global-iac-org-terraform",
    var.enterprise_name,
    "depends-on:${data.spacelift_current_stack.this.id}"
  ]
}

data "spacelift_account" "this" {}

data "spacelift_space" "root" {
  space_id = "root"
}

data "spacelift_current_stack" "this" {}

data "spacelift_stack" "this" {
  stack_id = data.spacelift_current_stack.this.id
}

# Apart from setting environment variables on your Stacks, you can mount files
# directly in Spacelift's workspace. Let's retrieve the list of Spacelift's
# outgoing addresses and store it as a JSON file.
data "spacelift_ips" "ips" {}
