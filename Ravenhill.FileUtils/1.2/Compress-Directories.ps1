$BaseExtension = @{
  'cbz' = 'zip';
  'cbr' = 'rar';
  'cbt' = 'tar';
  'cb7' = '7z'  
}

function Compress-Directories {
  [Alias('cmdir')]
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # The directory containing the subdirectories to compress.
    [Parameter(Position = 0, 
      HelpMessage = "The directory containing the subdirectories to compress.")]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string]
    $Path,
    # The format to compress the directory to.
    [Alias('f')]
    [Parameter(Mandatory, HelpMessage = "The format to compress the directory to.")]
    [ValidateSet('zip', 'rar', 'tar', '7z', 'bz2', 'gz', 'xz', 'cbz', 'cbr', 'cbt', 'cb7')]
    [string]
    $Format,
    # Flag to indicate if the original directories should be removed after compression.
    [Parameter(HelpMessage = "Flag to indicate if the original directories should be removed after compression.")]
    [switch]
    $Cleanup
  )
  Write-Verbose "Compressing directories in $Path to $Format"
  $Path = Resolve-Path -Path ($PSBoundParameters.ContainsKey('Path') ? $Path : $(Get-Location))
  Write-Debug "Resolved path: $Path"
  $Extension = $BaseExtension.ContainsKey($Format) ? $BaseExtension[$Format] : $Format
  Write-Debug "Resolved extension: $Extension"
  try {
    if ($Extension -eq 'zip') {
      Write-Verbose "Using native compression for $Extension"
      Compress-Archive -Path $Path -DestinationPath "$Path.$Extension" `
        -Verbose:$(Test-Verbose -Parameters $PSBoundParameters) `
        -Debug:$(Test-Debug -Parameters $PSBoundParameters)
    }
    else {
      $sz = Get-7ZipExecutablePath
      Write-Verbose "Using 7zip for $Extension"
      Get-ChildItem -Path $Path -Directory | ForEach-Object {
        & "$sz" a $("$($_.FullName).$Extension") $_.FullName
      }
      if (-not ($Extension -eq $Format)) {
        Get-ChildItem -Path $Path -Filter *.$Extension | `
          Move-Item -Destination { [System.IO.Path]::ChangeExtension($_.FullName, $Format) } `
          -Force -Verbose:$(Test-Verbose -Parameters $PSBoundParameters) `
          -Debug:$(Test-Debug -Parameters $PSBoundParameters)
      }
    }
    if ($Cleanup) {
      $shouldProcess = $PSCmdlet.ShouldProcess($Env:COMPUTERNAME, 
        "Remove original directories in $Path")
      if ($shouldProcess) {
        Get-ChildItem -Path $Path -Directory | Remove-Item -Recurse -Force `
          -Verbose:$(Test-Verbose -Parameters $PSBoundParameters) `
          -Debug:$(Test-Debug -Parameters $PSBoundParameters)
      }
    }
  }
  catch {
    Write-Error $_.Exception.Message
  }
  <#
  .SYNOPSIS
    Compress all subdirectories of a directory into a given format.
  .DESCRIPTION
    Compress all subdirectories using 7zip.
    This function accepts all valid 7zip formats, along with some comic book formats (cbz, cbr, 
    cb7).
    After the compression is done, the original directories are removed.
    If no path is given, the current directory is used.
  .EXAMPLE
    Compress-Directories -Path "C:\Users\User\Documents\My Documents" -Format "zip" -Cleanup
  #>
}

function Get-7ZipExecutablePath {
  $7zip = Get-Item -Path (Get-ItemProperty `
      -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" `
    | Where-Object { $_.DisplayName -like "7-Zip*" }).UninstallString.Replace('"', '')
  $7zipInstallDir = Split-Path -Path $7zip -Parent
  $7zipExecutablePath = Join-Path $7zipInstallDir "7z.exe"
  if (-not (Test-Path $7zipExecutablePath -PathType Leaf)) {
    throw "7-Zip is not installed on this machine."
  }
  $7zipExecutablePath
  <#
  .SYNOPSIS
    Returns the path to the 7-Zip executable or throws an error if it's not installed.
  .DESCRIPTION
    The Get-7ZipExecutablePath function retrieves the path to the 7-Zip executable by querying the 
    Windows Registry to find the installation directory. If 7-Zip is not installed, it will throw an 
    error.
  .EXAMPLE
    PS C:\> Get-7ZipExecutablePath
    C:\Program Files\7-Zip\7z.exe
  #>
}