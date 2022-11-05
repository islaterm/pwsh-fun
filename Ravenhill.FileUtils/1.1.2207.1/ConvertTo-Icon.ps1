Import-Module Ravenhill.Console

function Test-Magick {
  [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
  param ()
  if (-not (Test-Command magick)) {
    Write-Warning 'ImageMagick is not installed. The function will now try to install it.'
    if ($PSCmdlet.ShouldProcess("$Env:COMPUTERNAME", "Install ImageMagick")) {
      if (-not (Test-Command winget)) {
        Write-Error "Winget is not installed. Please install it and try again."
        return
      }
      winget.exe install ImageMagick.ImageMagick
      Update-SessionEnvironment    
    }
    else {
      Write-Error "ImageMagick is not installed. Please install it and try again."
      return
    }
  }
}

function ConvertTo-Icon {
  [Alias('cti')]
  [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]
    $Path
  )
  begin {
    Write-Debug 'ConvertTo-Icon: begin'
    $originalErrorActionPreference = Set-ErrorActionPreference 'Stop'
    Test-Magick
  }
  process {
    write-debug 'ConvertTo-Icon: process'
    $resolvedPath = Resolve-Path $Path
    Write-Debug "Resolved path: $resolvedPath"
  }
  end {
    Write-Debug 'ConvertTo-Icon: end'
    $ErrorActionPreference = $originalErrorActionPreference
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