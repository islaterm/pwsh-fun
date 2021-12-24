function Invoke-GradleRun {
  param (
    [string]
    [Parameter(Mandatory, Position = 0)]
    $Path,
    [string[]]
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    $Arguments
  )
  $originalLocation = Get-Location
  try {
    $params = @()
    $Arguments | ForEach-Object {
      $params += $_.ToString().StartsWith('-') ? $_ : "'$_'"
    }
    Set-Location $Path
    gradle run --args="$params"
  } finally {
    Set-Location $originalLocation
  }
  <#
    .SYNOPSIS
      Invokes a `gradle run` Task and waits for it to finish it's execution.
    .PARAMETER Path
      The path to a folder containing a ``gradle.build`` or ``gradle.build.kts`` file.
  #>
}