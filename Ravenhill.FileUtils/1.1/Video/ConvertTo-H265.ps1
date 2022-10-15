Import-Module Ravenhill.ScriptUtils
Import-Module Ravenhill.Exceptions

function ConvertTo-H265 {
  [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess)]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $InputFile,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $OutputFile
  )
  begin {
    Write-Debug 'ConvertTo-H265: begin'
    $ffmpeg = 'ffmpeg'
    try {
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
    catch [NotInstalledException] {
      Write-Error $_.Message
      $PSCmdlet.ThrowTerminatingError($_)
    }
  }
  process {
    Write-Debug 'ConvertTo-H265: process'
    Write-Debug "Input file: $InputFile"
    Write-Debug "Output file: $OutputFile"
    # 1 - Check if the input file exists
    # 2 - Check if the output file exists
    # 3 - Input format (regex)
    # 4 - ffmpeg command
    # 5 - Cleanup
  }
  end {
    Write-Debug 'ConvertTo-H265: end'
    Write-Verbose 'ConvertTo-H265: done'
  }
  <#
    .SYNOPSIS
      Convert video files to H.265 format.
  #>
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