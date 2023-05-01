function Remove-FilesByExtension {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param(
    [Parameter(Mandatory)]
    [string]$Path,
    [Parameter(Mandatory)]
    [string]$Extension
  )
  $isVerbose = $PSBoundParameters.ContainsKey('Verbose') ? $Verbose : $false
  $isDebug = $PSBoundParameters.ContainsKey('Debug') ? $Debug : $false
  Write-Debug "Starting Remove-FilesByExtension function..."
  $resolvedPath = Resolve-Path $Path
  Write-Verbose "Removing files with extension '$Extension' from '$resolvedPath'"
  $shouldProcess = $PSCmdlet.ShouldProcess($env:COMPUTERNAME, 
    "Remove files with extension '$Extension' from '$resolvedPath'")
  Write-Debug "ShouldProcess result: $shouldProcess"
  $ConfirmPreference = 'None'
  if ($shouldProcess) {
    $filesToRemove = Get-ChildItem -Path $resolvedPath -Recurse -Filter "*.$Extension" `
      -Verbose:$isVerbose -Debug:$isDebug
    Write-Debug "Files to be removed:`n$($filesToRemove.FullName -join "`n")"
    $filesToRemove | Remove-Item -Force -Verbose:$isVerbose -Debug:$isDebug
    Write-Verbose "Removed $($filesToRemove.Count) files with extension '$Extension'"
  }
  else {
    Write-Verbose "Remove-FilesByExtension was not executed due to user cancellation"
  }
  Write-Debug "Ending Remove-FilesByExtension function..."
}