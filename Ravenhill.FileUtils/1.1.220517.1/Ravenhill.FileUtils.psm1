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
