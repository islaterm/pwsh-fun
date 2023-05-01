function Remove-FilesByExtension {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param(
    # Specifies the directory from which files with the specified extension should be removed.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $Path,
    # Specifies the extension of the files to be removed.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $Extension
  )
  begin {
    Write-Debug "Starting Remove-FilesByExtension function..."
    $isVerbose = $PSBoundParameters.ContainsKey('Verbose') ? $Verbose : $false
    $isDebug = $PSBoundParameters.ContainsKey('Debug') ? $Debug : $false
    Write-Debug "Starting Remove-FilesByExtension function..."
    $resolvedPath = Resolve-Path $Path
    Write-Verbose "Removing files with extension '$Extension' from '$resolvedPath'"
    $shouldProcess = $PSCmdlet.ShouldProcess($env:COMPUTERNAME, 
      "Remove files with extension '$Extension' from '$resolvedPath'")
    Write-Debug "ShouldProcess result: $shouldProcess"
    $ConfirmPreference = 'None'
  }
  process {
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
  }
  end {
    Write-Debug "Ending Remove-FilesByExtension function..."
  }
  <#
  .SYNOPSIS
    Removes files with a given extension from a specified directory.
  .DESCRIPTION
    The Remove-FilesByExtension function is used to remove all files with a specified extension from a given directory, including all subdirectories. It supports the ShouldProcess functionality, which allows the user to preview the operation and confirm or cancel it. Debug and verbose messages can also be enabled.
  .EXAMPLE
    PS C:\> Remove-FilesByExtension -Path "C:\Users\John\Documents" -Extension "docx"
    This example removes all files with the extension ".docx" from the directory 
    "C:\Users\John\Documents", including all subdirectories.
    It uses the pipeline to pass the files to be removed to the Remove-FilesByExtension function.
  .LINK
    https://github.com/r8vnhill/pwsh-fun/blob/master/Ravenhill.FileUtils/1.1/Remove-FilesByExtension.ps1
  #>
}