function Set-EnvironmentVariable {
  param(
    # The name of the environment variable to set.
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    $Key,
    # The value of the environment variable to set.
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $Value,
    # Designates the current user as the owner of the environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "UserSet")]
    [Alias('u')]
    [Switch]
    $User,
    # Designates the current machine as the owner of the environment variable.
    [Parameter(Mandatory = $true, ParameterSetName = "MachineSet")]
    [Alias('m')]
    [Switch]
    $Machine
  )
  if ($User) {
    [System.Environment]::SetEnvironmentVariable($Key, $Value, 
        [System.EnvironmentVariableTarget]::User)
  } elseif ($Machine) {
    [System.Environment]::SetEnvironmentVariable($Key, $Value, 
        [System.EnvironmentVariableTarget]::Machine)
  } else {
    throw "Invalid scope" # This line is unreachable on purpose.
  }
  <#
  .SYNOPSIS
    Sets an environment variable.
  .DESCRIPTION
    Sets a new or existing environment variable as a key-value pair with a given scope.
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
Set-Alias -Name setenv -Value Set-EnvironmentVariable