param(
  [Parameter(Mandatory=$true)]
  [string]$Path
)

if (-Not (Test-Path -LiteralPath $Path)) {
  Write-Error "Path '$Path' does not exist."
  exit 1
}

# Remove all child files and folders
Get-ChildItem -LiteralPath $Path -Force | Remove-Item -Recurse -Force
Write-Host "All child files and folders removed from '$Path'."
