function ConvertTo-Icon {
  [Alias('cti')]
  param (
    # Specifies the objects that are converted to ICO files. 
    # You can also pipe objects to `ConvertTo-ICO`.
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    $InputObject,
    # The path to the output icon file(s)
    [string]
    $Output,
    # The size of the icon in pixels, defaults to 256x256
    [Alias('IconSize', 's')]
    [string]
    $Size = '256x256',
    # If present, the original image will be removed after conversion
    [Alias('RemoveOriginal', 'c')]
    [switch]
    $Cleanup
  )
  begin {
    Test-Regex -Test $Size -Pattern '^\d+x\d+$' `
      -FailureMessage "The icon size must be in the format '<width>x<height>'"
  }
  process {
    $OutputExist = $Output.Length -ne 0
    if ($OutputExist -and $Output.Length -ne $InputObject.Length) {
      throw "The number of files to convert must match the number of output files."
    }
    if (-not (Test-Command -Command magick)) {
      Request-Confirmation -Caption 'Warning' `
        -Message 'This command requires ImageMagick. Would you like to install it?' -IfTrue { 
        winget.exe install ImageMagick.ImageMagick
        Update-SessionEnvironment 
      }
    }
    for ($i = 0; $i -lt $InputObject.Count; $i++) {
      $InputObject = Get-Item $InputObject[$i]
      $OutputName = $OutputExist ? $Output[$i] : "${File.BaseName}.ico"
      Write-Verbose "Converting $InputObject to $OutputName.ico"
      $exe = 'magick.exe'
      [System.Collections.ArrayList]$arguments = @('convert')
      if (Test-Verbose($PSCmdlet)) {
        $arguments.Add('-verbose')
      }
      $arguments.AddRange( @('-background', 'none', '-resize' , $Size, '-density', $Size, 
          "`"$InputObject`"", "`"$OutputName`""))
      Write-Verbose "Executing $exe $arguments"
      & $exe $arguments
      if ($Cleanup -and (Test-Path -Path $OutputName)) {
        Remove-Item -Path $InputObject -Force -Verbose:$Verbose
      }
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