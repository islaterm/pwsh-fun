
# function Invoke-GradleRun {
#   param (
#     [string]
#     [Parameter(Mandatory, Position = 0)]
#     $Path,
#     [string[]]
#     [Parameter(Position = 1, ValueFromRemainingArguments)]
#     $Arguments
#   )
#   $originalLocation = Get-Location
#   try {
#     $params = @()
#     $Arguments | ForEach-Object {
#       $params += $_.ToString().StartsWith('-') ? $_ : "'$_'"
#     }
#     Set-Location $Path
#     if ($params.Length -gt 0) {
#       gradle run --args="$params"  
#     } else {
#       gradle run
#     }
#   }
#   finally {
#     Set-Location $originalLocation
#   }
#   <#
#     .DESCRIPTION
#       Invokes a `gradle run` Task and waits for it to finish it's execution.
#     .PARAMETER Path
#       The path to a folder containing a ``gradle.build`` or ``gradle.build.kts`` file.
#   #>
# }
function Search-ChocolateyPackage {
  [Alias('chs', 'schp')]
  param (
    [Mandatory]
    [string]
    $Name
  )
  choco.exe search $Name  
}