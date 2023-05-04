function Test-Command {
  param (
    # The name of the command to check.
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]
    $Command
  )
  begin {
    $commands = Get-Command -Name $Command -ErrorAction SilentlyContinue
  }
  process {
    $null -ne $commands
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