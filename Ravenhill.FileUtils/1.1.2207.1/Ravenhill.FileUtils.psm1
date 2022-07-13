. $PSScriptRoot\Ravenhill.FileUtils_aux.ps1

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

function ConvertTo-Icon {
  param (
    # The path to the image file(s) to convert
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]]
    $Files,
    # The path to the output icon file(s)
    [string[]]
    $OutputFiles,
    # The size of the icon in pixels, defaults to 256x256
    [Alias('IconSize', 's')]
    [string]
    $Size = '256x256',
    # If present, the original image will be removed after conversion
    [Alias('RemoveOriginal', 'c')]
    [switch]
    $Cleanup
  )
  Test-Regex -Test $Size -Pattern '^\d+x\d+$' `
    -FailureMessage "The icon size must be in the format '<width>x<height>'"
  $outputFilesExist = $OutputFiles.Length -ne 0
  if ($outputFilesExist -and $OutputFiles.Length -ne $Files.Length) {
    throw "The number of files to convert must match the number of output files."
  }
  if (-not (Test-Command -Command magick)) {
    Request-Confirmation -Caption 'Warning' `
      -Message 'This command requires ImageMagick. Would you like to install it?' -IfTrue { 
      winget.exe install ImageMagick.ImageMagick
      Update-SessionEnvironment 
    }
  }
  for ($i = 0; $i -lt $Files.Count; $i++) {
    $File = Get-Item $Files[$i]
    $OutputName = $outputFilesExist ? $OutputFiles[$i] : "${File.BaseName}.ico"
    Write-Verbose "Converting $File to $OutputName.ico"
    $exe = 'magick.exe'
    [System.Collections.ArrayList]$arguments = @('convert')
    if (Test-Verbose($PSCmdlet)) {
      $arguments.Add('-verbose')
    }
    $arguments.AddRange( @('-background', 'none', '-resize' , $Size, '-density', $Size, 
        "`"$File`"", "`"$OutputName`""))
    Write-Verbose "Executing $exe $arguments"
    & $exe $arguments
    if ($Cleanup -and (Test-Path -Path $OutputName)) {
      Remove-Item -Path $File -Force -Verbose:$Verbose
    }
  }
  <#
  .SYNOPSIS
    Converts image files to the widely-supported ICO format.
  .DESCRIPTION
    This command converts image files to ICO format.
    The image files are converted to the ICO format using ImageMagick.
    If ImageMagick is not installed, this command may fail.
  .EXAMPLE
    # Converts FolderIcon.png to FolderIcon.ico
    PS> ConvertTo-Icon -Files "D:\Pictures\FolderIcon.png" -OutputFiles "FolderIcon.ico"
  .EXAMPLE
    # Converts FolderIcon.png to FolderIcon.ico and removes the original file
    PS> ConvertTo-Icon -Files "D:\Pictures\FolderIcon.png" -OutputFiles "FolderIcon.ico" -Cleanup
  .EXAMPLE
    # Converts all .png to .ico in the current directory
    PS> Get-ChildItem *.png | ConvertTo-Icon
  .EXAMPLE
    # Converts all .png to .ico in the current directory with a 128x128 icon size
    PS> Get-ChildItem *.png | ConvertTo-Icon -Size 128x128
  .NOTES
    This command requires ImageMagick. In case it's not installed, the command will prompt the user
    to install it.
  #>
}