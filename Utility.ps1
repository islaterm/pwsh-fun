function Test-Application {
  [CmdletBinding(DefaultParameterSetName = 'Name')]
  param (
    # The display name of the application.
    [Parameter(Mandatory = $true, ParameterSetName = 'DisplayName', Position = 0)]
    [string]
    $DisplayName,
    # The name of the process that identifies the application.
    [Parameter(ValueFromPipeline = $true, ParameterSetName = 'Name', Position = 0)]
    [String]
    $Name
  )
  if ($Name) {
    $regKey = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'
    $process = $(Get-ChildItem "$regKey\*" | Where-Object { $_.Name.EndsWith("\$Name") })
    if ($process.Length -eq 0) {
      $process = $(Get-WmiObject -Class Win32_Process | Where-Object { $_.Name -eq $Name })
    }
  }
  else {
    $process = $(Get-ItemProperty "$regKey\*" | `
        Where-Object { $_.DisplayName -eq $DisplayName })
  }
  $process.Length -ne 0
  <#
  .SYNOPSIS
    Checks if an application is installed on the system.
  .OUTPUTS
    System.Boolean. Returns '$true' if the application is installed, 
    '$false' otherwise
  .EXAMPLE
    PS> Test-Application 'NVIDIA Web Helper.exe'
    # True if the service NVIDIA Web Helper is registered, False otherwise
  .EXAMPLE
    PS> Test-Application -Name '7-zip'
    # True if 7-zip is installed, false otherwise
  .EXAMPLE
    PS> Test-Application -DisplayName '3Tene'
    # True if 3Tene is installed, regardless of the installation method
    # (If using Steam this could have been registered with a 'Name' like Steam App XXXXXX)
  #>
}