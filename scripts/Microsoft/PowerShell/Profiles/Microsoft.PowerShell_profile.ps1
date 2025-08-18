
# Microsoft.PowerShell_profile.ps1
# Use $PROFILE to find where your profile is stored

# ISE Add-ons (only in ISE and Windows PowerShell 5.1)
if ($psISE -and $PSVersionTable.PSVersion.Major -eq 5) {
    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Clear()
    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Switch to PowerShell 7", { 
        function New-OutOfProcRunspace {
            param($ProcessId)
            $ci = New-Object -TypeName System.Management.Automation.Runspaces.NamedPipeConnectionInfo -ArgumentList @($ProcessId)
            $tt = [System.Management.Automation.Runspaces.TypeTable]::LoadDefaultTypeFiles()
            $Runspace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($ci, $Host, $tt)
            $Runspace.Open()
            $Runspace
        }
        $PowerShell = Start-Process PWSH -ArgumentList @("-NoExit") -PassThru -WindowStyle Hidden
        $Runspace = New-OutOfProcRunspace -ProcessId $PowerShell.Id
        $Host.PushRunspace($Runspace)
    }, "ALT+F5") | Out-Null

    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Switch to Windows PowerShell", { 
        $Host.PopRunspace()
        $Child = Get-CimInstance -ClassName win32_process | Where-Object {$_.ParentProcessId -eq $Pid}
        $Child | ForEach-Object { Stop-Process -Id $_.ProcessId }
    }, "ALT+F6") | Out-Null
}

# PROTECTIONS - prevent users from mucking things up
# Simplify making a temporary module path to use as a virtual environment
function Set-EnvironmentModulePath {
  param (
    [Parameter(Mandatory)]
    [string]$EnvironmentName,
    [switch]$Exclusive
  )
  $envRoot = Join-Path $HOME "PowerShellEnvironments"
  $envModulePath = Join-Path $envRoot $EnvironmentName
  if (-not (Test-Path $envModulePath)) {
    New-Item -ItemType Directory -Path $envModulePath | Out-Null
  }
  # Check if $envModulePath is already in $env:PSModulePath
  $paths = $env:PSModulePath -split ';'
  if ($paths -contains $envModulePath) {
    return
  }
  if ($Exclusive) {
    # This line sets the PSModulePath environment variable to the value of $envModulePath.
    # By doing this, any standard module paths previously in $env:PSModulePath are removed.
    # Standard module paths typically include:
    #   - $HOME\Documents\WindowsPowerShell\Modules
    #   - $HOME\Documents\PowerShell\Modules
    #   - $PSHOME\Modules
    #   - $env:ProgramFiles\WindowsPowerShell\Modules
    #   - $env:ProgramFiles\PowerShell\Modules
    #   - $env:Windir\System32\WindowsPowerShell\v1.0\Modules
    $env:PSModulePath = "$envModulePath;$PSHOME\Modules;$env:ProgramFiles\WindowsPowerShell\Modules;$env:ProgramFiles\PowerShell\Modules;$env:Windir\System32\WindowsPowerShell\v1.0\Modules"
  } else {
    $env:PSModulePath = "$envModulePath;" + $env:PSModulePath
  }
}

# I need to delete:
# - C:\Windows\System32\WindowsPowerShell\v1.0\Modules-Backup
# - C:\Program Files\PowerShell\Modules-Backup
# - C:\Program Files\WindowsPowerShell\Modules\Microsoft.PowerShell.Operation.Validation
# - C:\Program Files\WindowsPowerShell\Modules\Pester


# Safe Install-Module wrapper
function Install-SafeModule {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Name,
    [switch]$Force,
    [Parameter(ValueFromRemainingArguments = $true)]
    $RemainingArgs
  )
  $RemainingArgs.Force = $Force;
  $RemainingArgs.Scope = 'CurrentUser';
  Write-Host "Installing $Name to local scope only..." -ForegroundColor Cyan
  Microsoft.PowerShell.PackageManagement\Install-Module -Name $Name @RemainingArgs
}

# Custom prompt showing current directory and git branch (if available)
function prompt {
  $origin = $(Get-Location)
  $git = ""
  if (Get-Command git -ErrorAction SilentlyContinue) {
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    if ($branch) { $git = " [$branch]" }
  }
  $psversion = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
  "PS$psversion $origin$git> "
}

# ALIASES
# Alias to prevent accidental global installs
# Set-Alias Install-Module Install-SafeModule

# Common aliases
Set-Alias ll Get-ChildItem;
Set-Alias la "Get-ChildItem -Force -Hidden";
Set-Alias gs 'git status';

# PSReadLine enhancements
if (Get-Module -ListAvailable -Name PSReadLine) {
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -HistorySaveStyle SaveAtExit
    Set-PSReadLineOption -HistoryNoDuplicates
}

# Auto-import commonly used modules
Import-Module posh-git -ErrorAction SilentlyContinue

# CONVENIENCE FUNCTIONS
# Convenience function: open VS Code in current directory
function codehere { code . }

# SETTINGS

# Formatting options

# Increase history size
$MaximumHistoryCount = 4096

# Error handling
$ErrorActionPreference = 'Stop'

# ENVIRONMENT VARIABLES
# Make sure that we install modules to a default user environment
Set-EnvironmentModulePath -EnvironmentName "$env:USERNAME" -Exclusive:$true;

# To display your PowerShell profile path, run:
Write-Host "Your PowerShell profile path is: $PROFILE";
