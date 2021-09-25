function ConvertTo-MP3 {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true)]
      [string]
      $Path,
      [Alias("C")]
      [switch]
      $Cleanup
  )
  $originalLocation = Get-Location
  try {
    Set-Location $Path
    foreach ($file in $(Get-ChildItem -Exclude *.mp3)) {
      $target = "$($file.BaseName).mp3"
      ffmpeg.exe -y -i $file.Name -vn -ar 44100 -ac 2 -b:a 320k $target
      if ($Cleanup -and $(Test-Path -Path $target)){ 
        Remove-Item $file -Verbose
      } else {
        ffmpeg.exe -y -i $file.Name -vn -ar 44100 -ac 2 -b:a 320k "$($file.BaseName).mp3"
      }
    }
  } finally {
    Set-Location $originalLocation
  }
  <#
    .SYNOPSIS
      Converts a list of files to mp3.
    .DESCRIPTION
      Makes a conversion of all valid audio files of a directory to .mp3 extension using ffmpeg.
    .PARAMETER path
      The location of the audio files.
    .PARAMETER cleanup
      If present, source files will be removed after conversion (fot this, the scripts needs to 
      capture ffmpeg's console output).
  #>
}