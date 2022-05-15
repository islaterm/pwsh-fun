function Set-UserEnvironmentVariable {
  param (
    # The name of the environment variable to set.
    [Parameter(Mandatory = $true)]
    [string]
    $Key,
    # The value of the environment variable to set.
    [Parameter(Mandatory = $true)]
    [string]
    $Value
  )
  [System.Environment]::SetEnvironmentVariable($Key, $Value, 
    [System.EnvironmentVariableTarget]::User)
  <#
  .SYNOPSIS
    Sets an environment variable for the current user.
  .DESCRIPTION
    Sets a new or existing environment variable as a key-value pair for the current user as scope.
  .EXAMPLE
    PS> Set-UserEnvironmentVariable -Key "MyKey" -Value "MyValue"
    PS> Update-SessionEnvironment
    PS> Write-Host "MyKey: $env:MyKey"
    MyKey: MyValue
  .NOTES
    This change is persistent across sessions.
  #>
}