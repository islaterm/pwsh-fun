. $PSScriptRoot\Get-EnvironmentVariable.ps1

function Set-EnvironmentVariable {
  [Alias('setenv')]
  [CmdletBinding(SupportsShouldProcess)]
  param(
    # The name of the environment variable to set.
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Key,
    # The value of the environment variable to set.
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]
    $Value,
    # Designates the current user as the owner of the environment variable.
    [Parameter(Mandatory, ParameterSetName = "UserSet")]
    [Alias('u')]
    [Switch]
    $User,
    # Designates the current machine as the owner of the environment variable.
    [Parameter(Mandatory, ParameterSetName = "MachineSet")]
    [Alias('m')]
    [Switch]
    $Machine
  )
  begin {
    $oldValue = $User -eq $true ? $(Get-EnvironmentVariable -Key $Key -User) `
      : $(Get-EnvironmentVariable -Key $Key -Machine)
  }
  process {
    if ($PSCmdlet.ShouldProcess($User ? 'CurrentUser' : 'CurrentMachine', 
        "Set environment variable $Key to $Value.$(
          $null -ne $oldValue ? " Overriding existing value '$oldValue' with '$Value'": '')")) {
      if ($User) {
        [System.Environment]::SetEnvironmentVariable($Key, $Value, 
          [System.EnvironmentVariableTarget]::User)
      }
      elseif ($Machine) {
        [System.Environment]::SetEnvironmentVariable($Key, $Value, 
          [System.EnvironmentVariableTarget]::Machine)
      }
      else {
        throw "Invalid scope" # This line is unreachable on purpose.
      }
    }
  }
  end {
    Update-SessionEnvironment
  }
  <#
  .SYNOPSIS
    Sets an environment variable.
  .DESCRIPTION
    Sets a new or existing environment variable as a key-value pair with a given scope.
    Then, the session is updated to reflect the changes.
  .INPUTS
    A string representable value of the environment variable to set.
  .EXAMPLE
    PS> Set-EnvironmentVariable -Machine -Key "MyKey" -Value "MyValue"
    PS> Update-SessionEnvironment
    PS> Write-Host "MyKey: $env:MyKey"
    MyKey: MyValue
  .EXAMPLE
    PS> Get-Location | Set-EnvironmentVariable -User -Key "DEV_WORKSPACE"
  .EXAMPLE
    PS> # Note the order of the parameters in this call since it's using positional values
    PS> ls | setenv 'DEV_WORKSPACE' -u # This yields the same result as the previous example
  .NOTES
    This change is persistent across sessions.
  #>
}


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