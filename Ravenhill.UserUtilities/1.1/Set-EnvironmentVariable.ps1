function Set-EnvironmentVariable {
  [CmdletBinding(
    SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'UserSet')]
  [Alias('sev', 'setenv', 'Set-EnvVar')]
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
    Write-Verbose "Old value of $Key is '$oldValue'"
  }
  process {
    $shouldProcess = $PSCmdlet.ShouldProcess($User ? 'CurrentUser' : 'CurrentMachine', 
      "Set environment variable $Key to $Value.$(
      $null -ne $oldValue ? " Overriding existing value '$oldValue' with '$Value'": '')")
    if ($shouldProcess) {
      if ($User) {
        [System.Environment]::SetEnvironmentVariable($Key, $Value, 
          [System.EnvironmentVariableTarget]::User)
        Write-Debug "Set user environment variable $Key to $Value"
      }
      elseif ($Machine) {
        [System.Environment]::SetEnvironmentVariable($Key, $Value, 
          [System.EnvironmentVariableTarget]::Machine)
        Write-Debug "Set machine environment variable $Key to $Value"
      }
      else {
        throw "Invalid scope" # This line is unreachable on purpose.
      }
    }
  }
  end {
    Update-SessionEnvironment
    Write-Verbose "Updated session environment with new $Key value of '$Value'"
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