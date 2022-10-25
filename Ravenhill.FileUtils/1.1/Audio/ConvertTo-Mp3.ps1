Import-Module Ravenhill.ScriptUtils

function ConvertTo-MP3 {
  [CmdletBinding(ConfirmImpact = 'High')]
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
    Write-Debug 'ConvertTo-MP3: begin'
    try {
      Test-Ffmpeg
    }
    catch [NotInstalledException] {
      Write-Error $_.Message
      $PSCmdlet.ThrowTerminatingError($_)
    }
  }
  process {
    Write-Debug 'ConvertTo-MP3: process'
    $resolvedInput = Get-Item -LiteralPath $InputFile
    Write-Debug "Input file: $resolvedInput"
    if ($PSBoundParameters.ContainsKey('OutputFile')) {
      $resolvedOutput = Get-Item -LiteralPath $OutputFile
    }
    else {
      Write-Debug 'Output file: not specified'
      $resolvedOutput = Get-Item ($resolvedInput.FullName -replace '\.[^.]*$', '.mp3')
    }
    Write-Debug "Output file: $resolvedOutput"
  }
  
  end {
    
  }
}

function Test-AudioExtension {
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
  
}