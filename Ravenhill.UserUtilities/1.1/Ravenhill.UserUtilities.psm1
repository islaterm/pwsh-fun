. $PSScriptRoot\Get-EnvironmentVariable.ps1
. $PSScriptRoot\Set-EnvironmentVariable.ps1

function Set-HomeDirectory {
  param (
    # The path to the home directory to set.
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Path,
    # Bypass confirmation prompt. 
    [switch]
    $Confirm
  )
  if (-not $Confirm) {
    $Choices = '&Yes', '&No'
    $Decision = $Host.UI.PromptForChoice('Warning', 
      'This will override the default values of $HOME and `~`', $Choices, 1)
  }
  else {
    $Decision = 0
  }
  if ($Decision -eq 0) {
    $Path | Set-EnvironmentVariable -Key $HOME_DIR_KEY -User
    (Get-PSProvider FileSystem).Home = $Path
    Update-SessionEnvironment
  }
  <#
  .SYNOPSIS
    Sets the home directory of the current user.
  .DESCRIPTION
    Registers the `$Env:USER_HOME_DIR` environment variable to the given path as the home directory 
    of the current user.
  .INPUTS
    The path to the home directory.
  .NOTES
    This action will override the default values of $HOME and `~`, be wary that this change has 
    unpredictable side effects with other modules that depend on these values.
    This DOES NOT change the user profile location (`$Env:USERPROFILE`).
  .EXAMPLE
    PS> Set-HomeDirectory -Path "C:\Users\MyUser"
    PS> Get-HomeDirectory
    C:\Users\MyUser
  .LINK
    Get-HomeDirectory
  #>
}

function Get-HomeDirectory { 
  Get-EnvironmentVariable -Key $HOME_DIR_KEY -User
  <#
  .SYNOPSIS
    Returns the home directory of the current user.
  .DESCRIPTION
    Retrieves the value set for the `$Env:USER_HOME_DIR` environment variable.
  .OUTPUTS
    The path to the home directory.
  .EXAMPLE
    PS> Get-HomeDirectory | Write-Host
    C:\Users\MyUser
  .EXAMPLE
    PS> Get-HomeDirectory | Set-Location
    PS> Get-Location | Write-Host
    C:\Users\MyUser
  .EXAMPLE
    PS> cd ~
    PS> Get-Location | Write-Host
    C:\Users\MyUser
  .LINK
    Set-HomeDirectory
  #>
}

# TODO Add to path