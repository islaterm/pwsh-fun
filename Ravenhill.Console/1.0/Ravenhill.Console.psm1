function Reset-PowershellConsole {
  param (
    # If present, then opens an elevated PS console.
    [Alias('a')]
    [switch]
    $Admin
  )
  $Admin ? (pwsh.exe -new_console:a) : (pwsh.exe -new_console)
  exit
  <#
  .SYNOPSIS
    Opens a new PowerShell console and closes the current one.
  .DESCRIPTION
    Uses the Conemu functions to create a new console and close the current one, with admin 
    privileges if the $Admin flag is given.
  .EXAMPLE
    PS> Reset-PowershellConsole -Admin
  #>
}
Set-Alias -Name psx -Value Reset-PowershellConsole