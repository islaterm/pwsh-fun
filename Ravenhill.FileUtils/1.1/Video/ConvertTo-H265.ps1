Import-Module Ravenhill.ScriptUtils
Import-Module Ravenhill.Exceptions

# TODO: Add support for input files or folders.
# TODO: Add support for output files or folders.
# TODO: Add support for recursive search.
# TODO: Add support for ignoring files that already have the H.265 extension.
# TODO: Add support for ignoring files by name
# TODO: Add extension check
# TODO: Add ffmpeg check
function ConvertTo-H265 {
  [CmdletBinding()]
  param (
    [string]
    $Path = '.'
  )
  Get-ChildItem $Path | ForEach-Object {
    if (-not ("265" -in $_.Name)) {
      ffmpeg -i $_ -vcodec libx265 -crf 28 "$Path\$($_.BaseName).h265.mkv"
    }
  }
  <#
    .SYNOPSIS
      Convert video files to H.265 format.
  #>
}


function Script:Test-VideoExtension {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path,
    [scriptblock]
    $IfTrue,
    [scriptblock]
    $IfFalse
  )
  $resolvedFile = Get-Item -Path (Resolve-Path $InputFile)
  Write-Debug "Resolved path: $resolvedFile"
  if ($resolvedFile.Extension -in $videoExtensions) {
    Write-Debug "The file '$resolvedFile is a video file."
    & $IfTrue
  }
  else {
    Write-Debug "Format '.${$resolvedFile.Extension}' is not a video file."
    & $IfFalse
  }
  return $resolvedFile
}

function Script:Test-Ffmpeg {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param ()
  $ffmpeg = 'ffmpeg'
  Test-Command -Command $ffmpeg -IfFalse {
    Write-Warning "$ffmpeg is not installed. The function will now try to install it."
    if ($PSCmdlet.ShouldProcess("$Env:COMPUTERNAME", "Install $ffmpeg")) {
      Install-Ffmpeg
    }
    else {
      throw [NotInstalledException]::new(
        "$ffmpeg is not installed. Please install it and try again.")
    }
  }
}

function Script:Install-Ffmpeg {
  [CmdletBinding()]
  param ()
  Test-Command -Command 'choco' -IfTrue {
    choco.exe install $ffmpeg
  } -IfFalse {
    throw [NotInstalledException]::new(
      'Chocolatey is not installed. Please install it and try again.')
  }
  <#
    .DESCRIPTION
      Install ffmpeg using Chocolatey. If Chocolatey is not installed, the function will throw an 
      exception.
  #>
}

$videoExtensions = @(
  'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mpg', 'mpeg', 'vob', 'ogv', 'ogg', '3gp', 
  '3g2', '3gpp', '3gpp2', 'asf', 'asx', 'f4v', 'f4p', 'f4a', 'f4b')