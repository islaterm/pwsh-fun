function Set-EnvironmentVariable {
  param(
    # The value of the environment variable to set.
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $Value,
    # The name of the environment variable to set.
    [Parameter(Mandatory = $true)]
    [string]
    $Key,
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
  if ($PSBoundParameters.ContainsKey("User")) {
    [System.Environment]::SetEnvironmentVariable($Key, $Value, 
        [System.EnvironmentVariableTarget]::User)
  } elseif ($PSBoundParameters.ContainsKey("Machine")) {
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
  .EXAMPLE
    PS> Set-EnvironmentVariable -Machine -Key "MyKey" -Value "MyValue"
    PS> Update-SessionEnvironment
    PS> Write-Host "MyKey: $env:MyKey"
    MyKey: MyValue
  .EXAMPLE
    PS> Get-Location | Set-EnvironmentVariable -User -Key "DEV_WORKSPACE"
  .NOTES
    This change is persistent across sessions.
  #>
}
Set-Alias -Name setenv -Value Set-EnvironmentVariable