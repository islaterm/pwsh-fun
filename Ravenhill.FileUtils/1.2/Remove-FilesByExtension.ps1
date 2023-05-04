function Remove-FilesByExtension {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param(
    # Specifies the directory from which files with the specified extension should be removed.
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Path,

    # Specifies the extension(s) of the files to be removed.
    [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
    [string[]]
    $Extensions
  )

  begin {
    Write-Debug "Starting Remove-FilesByExtension function..."
    $isVerbose = $PSBoundParameters.ContainsKey('Verbose') ? $Verbose : $false
    $isDebug = $PSBoundParameters.ContainsKey('Debug') ? $Debug : $false
    Write-Debug "Starting Remove-FilesByExtension function..."
    if (-not (Test-Path $Path -Debug:$isDebug -Verbose:$isVerbose)) {
      throw "The specified path '$Path' does not exist"
    }
    $resolvedPath = Resolve-Path $Path -Debug:$isDebug -Verbose:$isVerbose
    Write-Verbose "Removing files with extensions '$($Extensions -join ",")' from '$resolvedPath'"
    $shouldProcess = $PSCmdlet.ShouldProcess($env:COMPUTERNAME, 
      "Remove files with extensions '$($Extensions -join ",")' from '$resolvedPath'")
    Write-Debug "ShouldProcess result: $shouldProcess"
    $ConfirmPreference = 'None'
  }

  process {
    if ($shouldProcess) {
      $filesToRemove = Get-ChildItem -Path $resolvedPath -Recurse | Where-Object {
        $_.Extensions.TrimStart('.') -in $Extensions
      } -Verbose:$isVerbose -Debug:$isDebug
      Write-Debug "Files to be removed:`n$($filesToRemove.FullName -join "`n")"
      $filesToRemove | Remove-Item -Force -Verbose:$isVerbose -Debug:$isDebug
      Write-Verbose "Removed $($filesToRemove.Count) files with extensions '$($Extensions -join ",")'"
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
    Removes files with a given extension(s) from a specified directory.
  .DESCRIPTION
    The Remove-FilesByExtension function is used to remove all files with specified extension(s) 
    from a given directory, including all subdirectories. It supports the ShouldProcess functionality, 
    which allows the user to preview the operation and confirm or cancel it. 
    Debug and verbose messages can also be enabled.
  .EXAMPLE
    PS C:\> Remove-FilesByExtension "C:\Users\John\Documents" -Extension "docx"
    This example removes all files with the extension ".docx" from the directory 
    "C:\Users\John\Documents", including all subdirectories.
  .EXAMPLE
    PS C:\> Remove-FilesByExtension "C:\Users\John\Pictures" -Extension "jpg","png"
    This example removes all files with the extensions ".jpg" and ".png" from the directory 
    "C:\Users\John\Pictures", including all subdirectories.
  .LINK
    https://github.com/r8vnhill/pwsh-fun/blob/master/Ravenhill.FileUtils/1.1/Remove-FilesByExtension.ps1
  #>
}
