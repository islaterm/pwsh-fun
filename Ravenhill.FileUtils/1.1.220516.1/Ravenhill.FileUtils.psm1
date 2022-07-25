function Remove-EmptyDirectories {
  param (
    # The path to the root of the directory tree to remove
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $Path
  )
  Robocopy.exe $Path $Path /S /move
  <#
  .SYNOPSIS
    Removes all empty directories in the given path.
  .DESCRIPTION
    This command removes all empty directories in the given path using 'Robust File Copy' (Robocopy)
    as the underlying tool.
  .INPUTS
    The path to the root of the directory tree to remove. 
  .EXAMPLE
    PS> tree /f
    Folder PATH listing for volume Roac
    Volume serial number is 584B-A34F
    C:.
    │   New Text Document.txt
    │
    ├───New folder
    │   └───New folder
    └───New folder (2)
    PS> Remove-EmptyDirectories '.'    
    ...
    PS> tree /f
    Folder PATH listing for volume Roac
    Volume serial number is 584B-A34F
    C:.
        New Text Document.txt

    No subfolders exist
  .LINK
    https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
  #>
}

$BaseExtension = @{
  'cbz' = 'zip';
  'cbr' = 'rar';
  'cbt' = 'tar';
  'cb7' = '7z'  
}

function Compress-Directories {
  [Alias('cmdir')]
  param (
    # The directory containing the subdirectories to compress.
    [Parameter(Mandatory,
      Position = 0,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Path to one or more locations.")]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string[]]
    $Path,
    # The format to compress the directory to.
    [Alias('f')]
    [Parameter(Mandatory = $true)]
    [ValidateSet('zip', 'rar', 'tar', '7z', 'bz2', 'gz', 'xz', 'cbz', 'cbr', 'cbt', 'cb7')]
    [string]
    $Format
  )

  $isVerbose = $PSBoundParameters.ContainsKey('Verbose') ? $Verbose : $false
  $isDebug = $PSBoundParameters.ContainsKey('Debug') ? $Debug : $false

  Write-Verbose "Compressing directories in $Path to $Format"
  $Path = $PSBoundParameters.ContainsKey('Path') ? $Path : $(Get-Location)
  Write-Debug "Resolved path: $Path"
  $Extension = $BaseExtension.ContainsKey($Format) ? $BaseExtension[$Format] : $Format
  Write-Debug "Resolved extension: $Extension"
  try {
    Test-7ZipInstallation
    Get-ChildItem -Path $Path -Directory | ForEach-Object {
      sz a "$($_.FullName).$Extension" $_.FullName 
    }
    if (-not ($Extension -eq $Format)) {
      Get-ChildItem -Path $Path -Filter *.$Extension | `
        Move-Item -Destination { [System.IO.Path]::ChangeExtension($_.FullName, $Format) } -Force `
        -Verbose:$isVerbose -Debug:$isDebug
    }
    Get-ChildItem -Path $Path -Directory | Remove-Item -Recurse -Force -Verbose:$isVerbose `
      -Debug:$isDebug
  } catch {
    Write-Error "Failed to compress directories in $Path to $Format"
    throw
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
      Compress-Directories -Path "C:\Users\User\Documents\My Documents" -Format "zip"
    .EXAMPLE
      'D:\Manga\Yoshihiro Togashi\Hunter X Hunter - 1998\' | Compress-Directories -Format cb7
    .EXAMPLE
      Compress-Directories -Format 7zip
  #>
}

function Test-7ZipInstallation {
  $7ZipProperty = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | `
    Where-Object { $_.PSChildName -eq '7-Zip' }
  if ($null -eq $7ZipProperty) {
    $Choices = '&Yes', '&No'
    $Decision = $Host.UI.PromptForChoice('Warning', 
      '7-zip is not installed. Would you like to install it?', $Choices, 1)
    if ($Decision -eq 0) {
      winget.exe install 7zip.7zip
    }
  }
  else {
    throw '7-zip is needed to compress directories.'
  }
  Set-Alias -Name sz -Value $7ZipProperty.InstallLocation\7z.exe
}
