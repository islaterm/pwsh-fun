function Get-PSModulesLocation {
  [Alias('gpsm', 'Get-PSModulesPath')]
  param ()
  "$((Get-Item $PROFILE).Directory.FullName)\Modules"
  <#
  .SYNOPSIS
    Gets the path to the PowerShell modules directory.
  .INPUTS
    None.
  .OUTPUTS
    System.String. The path to the PowerShell modules directory.
  .EXAMPLE
    PS> Get-PSModulesPath
    C:\Users\R8V\Documents\WindowsPowerShell\Modules
  .EXAMPLE
    PS> cd $(Get-PSModulesPath)
    PS> $pwd
    C:\Users\R8V\Documents\PowerShell\Modules
  #>
}