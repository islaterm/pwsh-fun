function Compress-Directories {
  [Alias('cmdir')]
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param (
    # The path to the root of the directory tree to compress
    [Parameter(Mandatory, 
      ParameterSetName = 'Path',
      HelpMessage = 'The path to the directories to compress.')]
    [string[]]
    $Path,
    # The path to the root of the directory tree to compress
    [Parameter(Mandatory, 
      ParameterSetName = 'LiteralPath',
      HelpMessage = 'The path to the directory to compress.')]
    [string]
    $LiteralPath
  )
  begin {
    $BaseExtension = @{
      'cbz' = 'zip';
      'cbr' = 'rar';
      'cbt' = 'tar';
      'cb7' = '7z'  
    }
    $ChildItems = $Path ? (Get-ChildItem -Path $Path) : (Get-ChildItem -LiteralPath $LiteralPath)
  }
  process {
    Write-Debug "Processing: $ChildItems"
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