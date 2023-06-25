. $PSScriptRoot\Ravenhill.FileUtils_aux.ps1
. $PSScriptRoot\Video\ConvertTo-H265.ps1
. $PSScriptRoot\Remove-FilesByExtension.ps1
. $PSScriptRoot\Compress-Directories.ps1

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

