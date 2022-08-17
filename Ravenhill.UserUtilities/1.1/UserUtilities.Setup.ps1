<#
.DESCRIPTION
  Sets the default values for the UserUtilities module.
#>
$HOME_DIR_KEY = 'USER_HOME_DIR'
if (-not $(Test-Path Env:$HOME_DIR_KEY)) {
  $OriginalLocation = Get-Location
  try {
    Set-Location ~
    $Here = Get-Location
    Write-Output "Setting $HOME_DIR_KEY to $Here"
    Env:$HOME_DIR_KEY = $Here
  }
  finally {
    Set-Location $OriginalLocation
  }
}