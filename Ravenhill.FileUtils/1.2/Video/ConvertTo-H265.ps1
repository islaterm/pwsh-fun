Import-Module Ravenhill.ScriptUtils
Import-Module Ravenhill.Exceptions

function ConvertTo-H265 {
  [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Alias('Path', 'i')]
    [string]
    $InputFile,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [Alias('o', 'Destination')]
    [string]
    $OutputFile
  )
  begin {
    Write-Debug 'ConvertTo-H265: begin'
    try {
      Test-Ffmpeg
    }
    catch [NotInstalledException] {
      Write-Error $_.Message
      $PSCmdlet.ThrowTerminatingError($_)
    }
  }
  process {
    Write-Debug 'ConvertTo-H265: process'
    Write-Debug "Input file: $InputFile"

    Test-VideoExtension -Path $InputFile -IfFalse {
      throw [IllegalArgumentException] "Input file is not a video file: $InputFile"
    }

    $resolvedFile = Get-Item $InputFile
    if (-not $OutputFile) {
      $OutputFile = $InputFile.Replace($resolvedFile.Extension, '.h265.mp4')
    }
    Write-Debug "Output file: $OutputFile"
    # 2 - Check if the output file exists
    # 3 - Input format (regex)
    # 4 - ffmpeg command
    ffmpeg.exe -i "$InputFile" -vcodec libx265 -crf 28 "$OutputFile"
    # 5 - Cleanup
  }
  end {
    # Write-Debug 'ConvertTo-H265: end'
    # Write-Verbose 'ConvertTo-H265: done'
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