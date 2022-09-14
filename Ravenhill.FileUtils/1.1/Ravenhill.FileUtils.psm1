function Remove-EmptyDirectories {
  param (
    # The path to the root of the directory tree to remove
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $Path
  )
  Robocopy.exe $Path $Path /S /move
  <#
  .SYNOPSIS
    Removes all empty directories in the given path.
  .DESCRIPTION
    This command removes all empty directories in the given path using 'Robust File Copy' (Robocopy)
    as the underlying tool.
  .INPUTS
    The path to the root of the directory tree to remove. 
  .EXAMPLE
    PS> tree /f
    Folder PATH listing for volume Roac
    Volume serial number is 584B-A34F
    C:.
    │   New Text Document.txt
    │
    ├───New folder
    │   └───New folder
    └───New folder (2)
    PS> Remove-EmptyDirectories '.'    
    ...
    PS> tree /f
    Folder PATH listing for volume Roac
    Volume serial number is 584B-A34F
    C:.
        New Text Document.txt

    No subfolders exist
  .LINK
    https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
  #>
}

function Test-7ZipInstallation {
  $7ZipProperty = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | `
    Where-Object { $_.PSChildName -eq '7-Zip' }
  if ($null -eq $7ZipProperty) {
    $Choices = '&Yes', '&No'
    $Decision = $Host.UI.PromptForChoice('Warning', 
      '7-zip is not installed. Would you like to install it?', $Choices, 1)
    if ($Decision -eq 0) {
      winget.exe install 7zip.7zip
    }
  }
  else {
    throw '7-zip is needed to compress directories.'
  }
  Set-Alias -Name sz -Value $7ZipProperty.InstallLocation\7z.exe
}
