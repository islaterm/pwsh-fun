Import-Module Ravenhill.ScriptUtils
Import-Module Ravenhill.Exceptions

# The original ConfirmPreference value.
$originalConfirmPreference = $ConfirmPreference
# The valid video extensions.
$videoExtensions = @(
  '.mp4', '.mkv', '.avi', '.wmv', '.mov', '.flv', '.webm', '.mpg', '.mpeg', '.m4v', '.m2v', '.3gp'
)

# TODO: Add support for input files or folders.
# TODO: Add support for output files or folders.
# TODO: Add support for recursive search.
# TODO: Add support for ignoring files that already have the H.265 extension.
# TODO: Add support for ignoring files by name
# TODO: Add ffmpeg check
# TODO: Add should process/check/cleanup
function ConvertTo-H265 {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # The path to the file or folder to convert.
    [string]
    $Path = '.'
  )
  try {
    if (-not (Test-Path $Path)) {
      throw [System.IO.FileNotFoundException] "The path '$Path' does not exist."
    }
    $videoFiles = Get-ChildVideos -Path $Path
    Write-Debug "Video files: $videoFiles"
    $shouldProcess = $PSCmdlet.ShouldProcess("$Env:COMPUTERNAME", 
      "Convert video files to H.265 format")
    if ($shouldProcess) {
      $ConfirmPreference = 'None'
      Convert-VideoFilesToH265 -Files $videoFiles -OutputPath $Path
    }
  }
  finally {
    $ConfirmPreference = $originalConfirmPreference
  }
  <#
    .SYNOPSIS
      Convert video files to H.265 format.
  #>
}

function Script:Get-ChildVideos {
  [CmdletBinding()]
  param (
    # The directory path where the videos will be searched
    [Parameter(Mandatory)]
    [string]
    $Path
  )

  $resolvedPath = Resolve-Path $Path
  Write-Debug "Resolved path: $resolvedPath"
  
  $children = Get-ChildItem $resolvedPath
  Write-Debug "Children: $children"

  $children | Where-Object { 
    Write-Verbose "Checking file: $_"
    Write-Debug "Extension: $($_.Extension)"
    $_.Extension -in $videoExtensions 
  }

  <#
  .SYNOPSIS
    Returns child items from a specified path that are video files.

  .DESCRIPTION
    The Get-ChildVideos function retrieves all child items from a given directory path
    that have extensions matching a predefined list of video extensions.

  .PARAMETER Path
    The directory path where the video files will be searched.

  .EXAMPLE
    Get-ChildVideos -Path "C:\videos\"
    This example retrieves all video files in the "C:\videos\" directory.
  #>
}

function Script:Convert-VideoFilesToH265 {
  [CmdletBinding()]
  param (
    # An array of FileSystemInfo objects representing video files to convert
    [Parameter(Mandatory)]
    [System.IO.FileSystemInfo[]]
    $Files,
    
    # The directory where the converted videos will be saved
    [Parameter(Mandatory)]
    [string]
    $OutputPath
  )

  $Files | ForEach-Object {
    if (-not ($_.Name -like '*.h265.*') -or `
        -not ($_.Name -like '*.x265.*')) {
      Write-Debug "Converting file: $_"
      ffmpeg -i $_ -vcodec libx265 -crf 28 "$OutputPath\$($_.BaseName).h265.mkv"
    }
    else {
      Write-Debug "Skipping file: $_"
    }
  }

  <#
  .SYNOPSIS
    Converts a list of video files to H265 format using ffmpeg.
  
  .DESCRIPTION
    The Convert-VideoFilesToH265 function converts a list of video files to H265 format. 
    It uses the ffmpeg command-line tool to perform the conversion. The function skips 
    any files that already appear to be in H265 format.
  
  .PARAMETER VideoFiles
    An array of FileSystemInfo objects that represent the video files to be converted.
  
  .PARAMETER OutputPath
    The directory where the converted videos will be saved.

  .NOTES
    This command assumes that ffmpeg is installed and available in the current path, and that the
    input files are in a format that ffmpeg can convert to H265.
  
  .EXAMPLE
    $files = Get-ChildItem -Path "C:\videos\" -File
    Convert-VideoFilesToH265 -VideoFiles $files -OutputPath "C:\converted\"
    This example converts all files in the "C:\videos\" directory to H265 format and 
    saves them in the "C:\converted\" directory.
  #>
}
