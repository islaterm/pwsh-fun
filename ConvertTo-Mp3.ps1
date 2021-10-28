function ConvertTo-MP3
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Path,
    [Alias('C')]
    [switch]
    $Cleanup
  )
  $originalLocation = Get-Location
  try
  {
    Set-Location $Path
    foreach ($element in $(Get-ChildItem -Exclude *.mp3, *.txt, *.jpg, *.part))
    {
      if ($element -is [System.IO.DirectoryInfo])
      {
        Write-Output ("$element is a directory, the program will proceed to convert the elements " `
            + 'inside the folder')
        ConvertTo-MP3 -Cleanup -Path $element
      }
      else
      {
        Write-Output "Converting $element"
        $target = [Io.Fileinfo]"$($element.BaseName).mp3"
        ffmpeg.exe -y -i $element.Name -vn -ar 44100 -ac 2 -b:a 320k $target
        if ($Cleanup -and $(Get-ChildItem -Path . -Filter $target).Length -ne 0)
        { 
          Remove-Item $element -Verbose
        }
      }
    }
  }
  finally
  {
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