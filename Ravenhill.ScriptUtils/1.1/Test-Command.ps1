function Test-Command {
  [CmdletBinding()]
  param (
    # The name of the command to check.
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]
    $Command,
    # ScriptBlock to execute if the command is found.
    [Parameter()]
    [scriptblock]
    $IfTrue,
    # ScriptBlock to execute if the command is not found.
    [Parameter()]
    [scriptblock]
    $IfFalse
  )
  Write-Debug "Test-Command: $Command"
  if (Get-Command $Command -ErrorAction SilentlyContinue) {
    Write-Debug "Test-Command: $Command found"
    if ($IfTrue) {
      & $IfTrue
    }
  }
  else {
    Write-Debug "Test-Command: $Command not found"
    if ($IfFalse) {
      & $IfFalse
    }
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