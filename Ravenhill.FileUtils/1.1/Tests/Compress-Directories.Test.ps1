Import-Module ..\Compress-Directories.ps1 -Force

$Script:TmpDir = 'tmp'
$Script:OriginalLocation = Get-Location

BeforeAll {
  if (-not (Test-Path -Path $TmpDir)) {
    New-Item -Path $TmpDir -ItemType Directory
  }
  New-Item -Path "$TmpDir\Test_1" -ItemType Directory
}

Describe 'Compress-Directories' {
  It 'Test_1 should be compressed to Test_1.zip' {
    Compress-Directories -Path "$TmpDir" -Debug #-Format zip
    Test-Path -Path "$TmpDir\Test_1.zip" | Should -Be $true
  }
}

AfterAll {
  Remove-Item -Path $TmpDir -Recurse -Force
}