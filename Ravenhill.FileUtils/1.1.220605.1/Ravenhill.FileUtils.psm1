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

# ConvertTo-Jpeg - Converts RAW (and other) image files to the widely-supported JPEG format
# https://github.com/DavidAnson/ConvertTo-Jpeg
function ConvertTo-Jpeg {
  Param (
    # The path to the images file to convert
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [String[]]
    $Files,
    # Fix extension of JPEG files without the .jpg extension
    [Switch]
    $FixExtensionIfJpeg
  )
  # Summary of imaging APIs: https://docs.microsoft.com/en-us/windows/uwp/audio-video-camera/imaging
  $Files | Foreach-Object -ThrottleLimit 5 -Parallel {
    #Action that will run in Parallel. Reference the current object via $PSItem and bring in outside 
    # variables with $USING:varname
    Write-Host $PSItem -NoNewline
  }
  # foreach ($file in $Files) {
  #   try {
  #     try {
  #       # Get SoftwareBitmap from input file
  #       $file = Resolve-Path -LiteralPath $file
  #       $inputFile = Wait-Task ([Windows.Storage.StorageFile]::GetFileFromPathAsync($file)) ([Windows.Storage.StorageFile])
  #       $inputFolder = Wait-Task ($inputFile.GetParentAsync()) ([Windows.Storage.StorageFolder])
  #       $inputStream = Wait-Task ($inputFile.OpenReadAsync()) ([Windows.Storage.Streams.IRandomAccessStreamWithContentType])
  #       $decoder = Wait-Task ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($inputStream)) ([Windows.Graphics.Imaging.BitmapDecoder])
  #     }
  #     catch {
  #       # Ignore non-image files
  #       Write-Host " [Unsupported]"
  #       continue
  #     }
  #     if ($decoder.DecoderInformation.CodecId -eq [Windows.Graphics.Imaging.BitmapDecoder]::JpegDecoderId) {
  #       $extension = $inputFile.FileType
  #       if ($FixExtensionIfJpeg -and ($extension -ne ".jpg") -and ($extension -ne ".jpeg")) {
  #         # Rename JPEG-encoded files to have ".jpg" extension
  #         $newName = $inputFile.Name -replace ($extension + "$"), ".jpg"
  #         Wait-Action ($inputFile.RenameAsync($newName))
  #         Write-Host " => $newName"
  #       }
  #       else {
  #         # Skip JPEG-encoded files
  #         Write-Host " [Already JPEG]"
  #       }
  #       continue
  #     }
  #     $bitmap = Wait-Task ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])

  #     # Write SoftwareBitmap to output file
  #     $outputFileName = $inputFile.Name + ".jpg";
  #     $outputFile = Wait-Task ($inputFolder.CreateFileAsync($outputFileName, [Windows.Storage.CreationCollisionOption]::ReplaceExisting)) ([Windows.Storage.StorageFile])
  #     $outputStream = Wait-Task ($outputFile.OpenAsync([Windows.Storage.FileAccessMode]::ReadWrite)) ([Windows.Storage.Streams.IRandomAccessStream])
  #     $encoder = Wait-Task ([Windows.Graphics.Imaging.BitmapEncoder]::CreateAsync([Windows.Graphics.Imaging.BitmapEncoder]::JpegEncoderId, $outputStream)) ([Windows.Graphics.Imaging.BitmapEncoder])
  #     $encoder.SetSoftwareBitmap($bitmap)
  #     $encoder.IsThumbnailGenerated = $true

  #     # Do it
  #     Wait-Action ($encoder.FlushAsync())
  #     Write-Host " -> $outputFileName"
  #   }
  #   catch {
  #     # Report full details
  #     throw $_.Exception.ToString()
  #   }
  #   finally {
  #     # Clean-up
  #     if ($inputStream -ne $null) { [System.IDisposable]$inputStream.Dispose() }
  #     if ($outputStream -ne $null) { [System.IDisposable]$outputStream.Dispose() }
  #   }
  # }
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
    $Size = '256x256'
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
    $baseName = $outputFilesExist ? $OutputFiles[$i] : $File
    Write-Verbose "Converting $File to $baseName.ico"
    $exe = 'magick.exe'
    [System.Collections.ArrayList]$arguments = @('convert')
    if (Test-Verbose($PSCmdlet)) {
      $arguments.Add('-verbose')
    }
    $arguments.AddRange( @('-background', 'none', '-resize' , $Size, '-density', $Size, 
        "`"$File`"", "`"$baseName.ico`""))
    Write-Verbose "Executing $exe $arguments"
    & $exe $arguments
  }
  <#
  .SYNOPSIS
    Converts image files to the widely-supported ICO format.
  .DESCRIPTION
    This command converts image files to ICO format.
    The image files are converted to the ICO format using ImageMagick.
    If ImageMagick is not installed, this command will fail.
  .EXAMPLE
    PS> ConvertTo-Icon 'C:\My Pictures\*.jpg'
  .NOTES
    This command requires ImageMagick. You can install it with "winget install ImageMagick.ImageMagick"
  #>
}

function Test-Verbose {
  param (
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.PSCmdlet]
    $Cmdlet
  )
  return $Cmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent
}

function Test-Regex {
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Test,
    [Parameter(Mandatory = $true)]
    [string]
    $Pattern,
    [Parameter(Mandatory = $true)]
    [string]
    $FailureMessage
  )
  if (-not ($Test -match $Pattern)) {
    throw $FailureMessage
  }
}

function Request-Confirmation {
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Caption,
    [Parameter(Mandatory = $true)]
    [string]
    $Message,
    [Parameter(Mandatory = $true)]
    [scriptblock]
    $IfTrue,
    [scriptblock]
    $IfFalse
  )
  $Choices = '&Yes', '&No'
  $Decision = $Host.UI.PromptForChoice($Caption, $Message, $Choices, 1)
  if ($Decision -eq 0) {
    $IfTrue.Invoke()
  }
  else {
    $IfFalse.Invoke()
  }
}