function Test-Ffmpeg {
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
  <#
    .SYNOPSIS
      Tests if ffmpeg is installed.
    .DESCRIPTION
      Tests if ffmpeg is installed. If it is not, it will try to install it.
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