#!/usr/bin/env bash
set -euo pipefail

# Example: adapt these from your CI / env or values in variables.tf
export ARM_SUBSCRIPTION_ID=""
export ARM_TENANT_ID=""            # var.azure_tenant_id
# export ARM_CLIENT_ID="<SP_CLIENT_ID>"
# export ARM_CLIENT_SECRET="<SP_CLIENT_SECRET>"

# Optional: use az login with managed identity instead of client creds
# az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"

# Install terraformer (pick a stable release)
if ! command -v terraformer >/dev/null 2>&1; then
  echo "Install terraformer first (https://github.com/GoogleCloudPlatform/terraformer/releases)"
  exit 1
fi

# Create output dir per provider
OUTDIR="imports"
mkdir -p "${OUTDIR}"

# 1) Import Azure ARM resources supported by terraformer
#    - Replace the resources list with the specific resource types you want. 
#    - You can run multiple imports (per resource group / subscription) to limit scope.
# Example (template; check your terraformer version for exact flags you should use):
terraformer import azure \
  --resources="resource_group,virtual_network,subnet,network_interface,public_ip,storage_account,sql_server,app_service,container_registry,kubernetes_cluster" \
  --output="${OUTDIR}/azurerm" \
  --connect=true

# 2) Import Entra / Azure AD objects (users, groups, app registrations) if supported
terraformer import azuread \
  --resources="user,group,application,service_principal" \
  --output="${OUTDIR}/azuread"

# 3) Move / review generated TF into your module (enterprise/)
#    - terraformer will create providers and state stubs; prefer to merge into your existing
#      module that already defines [`provider "azurerm"`](enterprise/provider.tf) and friends.
#    - Manually reconcile providers in [enterprise/versions.tf](enterprise/versions.tf).
# Example: copy files and tidy
# cp -r "${OUTDIR}/azurerm"/* enterprise/ || true
# cp -r "${OUTDIR}/azuread"/* enterprise/ || true

echo "IMPORT COMPLETE. Review, refactor generated TF, remove provider blocks duplicated with your [enterprise/provider.tf](enterprise/provider.tf), then run 'terraform init' and 'terraform plan'."