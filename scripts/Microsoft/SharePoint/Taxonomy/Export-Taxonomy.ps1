param(
  [Parameter(Mandatory = $true)]
  [string]$TenantName,
  [Parameter(Mandatory = $false)]
  [string]$ClientId,
  [Parameter(Mandatory = $false)]
  [string]$CertificatePath,
  [Parameter(Mandatory = $false)]
  [securestring]$CertificatePassword
)

# This script uses Microsoft365 Tools, so we use that environment
$EnvironmentName = "Microsoft365";
Set-EnvironmentModulePath $EnvironmentName;
$envRoot = Join-Path $HOME "PowerShellEnvironments";
$envModulePath = Join-Path $envRoot $EnvironmentName;

if ($PSVersionTable.PSEdition -eq 'Desktop') {
    # Windows PowerShell 5.1: use PnP.PowerShell 1.12.0
    if (Get-Module -ListAvailable -Name PnP.PowerShell | Where-Object { $_.Version -gt [version]'1.12.0' }) {
        Write-Host "Removing incompatible PnP.PowerShell module versions..."
        Get-Module -ListAvailable -Name PnP.PowerShell | Where-Object { $_.Version -gt [version]'1.12.0' } | ForEach-Object {
            Remove-Item -Recurse -Force $_.ModuleBase
        }
    }
    if (-not (Get-Module -ListAvailable -Name PnP.PowerShell | Where-Object { $_.Version -eq [version]'1.12.0' })) {
        Save-Module PnP.PowerShell -RequiredVersion 1.12.0 -Path $envModulePath -Force;
    }
    Import-Module PnP.PowerShell -RequiredVersion 1.12.0 -Force
} else {
    # Check if a newer version is available online
    $latest = Find-Module PnP.PowerShell -ErrorAction SilentlyContinue
    $local = Get-Module -ListAvailable -Name PnP.PowerShell | Sort-Object Version -Descending | Select-Object -First 1

    if ($latest -and (!$local -or $latest.Version -gt $local.Version)) {
        Write-Host "A newer version ($($latest.Version)) of PnP.PowerShell is available. Downloading..."
        try {
            Save-Module PnP.PowerShell -Path $envModulePath -Force
        } catch {
            Write-Warning "Could not save PnP.PowerShell module: $($_.Exception.Message)"
        }
    } else {
        Write-Host "PnP.PowerShell module is up to date (version $($local.Version)) at $envModulePath"
    }
}

Import-Module PnP.PowerShell -Force;

# Print the loaded PnP.PowerShell version
$pnppsm = Get-Module PnP.PowerShell
if ($pnppsm) {
    Write-Host "PnP.PowerShell version loaded: $($pnppsm.Version)";
} else {
    Write-Warning "PnP.PowerShell module not loaded.";
}

$spAdminUrl = "https://$TenantName-admin.sharepoint.com"

try {
    # Dynamically build parameter hashtable for non-empty values
    $connectParams = @{
        Url = $spAdminUrl
    }
    # if ($ClientId) { $connectParams.ClientId = $ClientId }
    # if ($TenantName) { $connectParams.Tenant = "$TenantName.onmicrosoft.com" }
    # if ($CertificatePath) { $connectParams.CertificatePath = $CertificatePath }
    # if ($CertificatePassword) { $connectParams.CertificatePassword = $CertificatePassword }
    Write-Host "Connect-PnPOnline parameters:"
    $connectParams.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }
    Connect-PnPOnline @connectParams -Interactive;
} catch {
    Write-Warning "Interactive login failed, trying device login..."
    try {
        # Dynamically build parameter hashtable for non-empty values
        $connectParams = @{
            Url = $spAdminUrl
        }
        Write-Host "Connect-PnPOnline parameters:"
        $connectParams.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }
        Connect-PnPOnline @connectParams -DeviceLogin -Verbose;
    } catch {
        Write-Warning "Device login failed, trying web login..."
        # Dynamically build parameter hashtable for non-empty values
        $connectParams = @{
            Url = $spAdminUrl
        }
        if ($ClientId) { $connectParams.ClientId = $ClientId }
        Write-Host "Connect-PnPOnline parameters:"
        $connectParams.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" }
        Connect-PnPOnline @connectParams -OSLogin;
    }
}

Export-PnPTermGroupToXml -Out "$PSScriptRoot\Taxonomy.xml";
