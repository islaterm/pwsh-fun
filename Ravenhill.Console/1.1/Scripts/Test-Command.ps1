function Test-Command {
  param (
    # The name of the command to check.
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $Command
  )
  $originalErrorAction = Set-ErrorActionPreference -Preference 'Stop'
  try {
    if (Get-Command $Command) {
      return $true
    }
  }
  catch {
    return $false
  }
  finally {
    $ErrorActionPreference = $originalErrorAction
  }
  <#
  .SYNOPSIS
    Checks if a command exists.
  .INPUTS
    System.String. The name of the command to check.
  .OUTPUTS
    <Bool>. Test-Command returns '$true' if the command exists, 
    '$false' otherwise
  .EXAMPLE
    PS> Test-Command winget
    True
  .EXAMPLE
    PS> Test-Command julia
    False
  .EXAMPLE
    PS> 'julia' | Test-Command
    False
  #>
}