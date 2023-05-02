function Get-EnvironmentVariable {
  [CmdletBinding()]
  [Alias('Get-EnvVar', "gev")]
  param(
    # Specifies the name of the environment variable to retrieve.
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Key,
    # Specifies that the environment variable should be retrieved from the user level.
    [Parameter(Mandatory, ParameterSetName = "UserSet")]
    [Alias('u')]
    [Switch]
    $User,
    # Specifies that the environment variable should be retrieved from the machine level.
    [Parameter(Mandatory, ParameterSetName = "MachineSet")]
    [Alias('m')]
    [Switch]
    $Machine
  )
  if ($User) {
    [System.Environment]::GetEnvironmentVariable($Key, [System.EnvironmentVariableTarget]::User)
  }
  elseif ($Machine) {
    [System.Environment]::GetEnvironmentVariable($Key, [System.EnvironmentVariableTarget]::Machine)
  }
  else {
    throw "Invalid scope" # This line is unreachable on purpose.
  }
  <#
  .SYNOPSIS
    Gets the value of an environment variable, either from the user or machine level.
  .DESCRIPTION
    This function gets the value of the specified environment variable, either from the user or 
    machine level.
  .EXAMPLE
    Get-EnvironmentVariable -Key "Path" -Machine
    Retrieves the value of the PATH environment variable from the machine level.
  .EXAMPLE
    Get-EnvironmentVariable -Key "TEMP" -User
    Retrieves the value of the TEMP environment variable from the user level.
  #>
}