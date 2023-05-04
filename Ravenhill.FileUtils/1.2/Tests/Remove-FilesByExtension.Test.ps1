Describe 'Remove-FilesByExtension' {
  BeforeEach {
    # Create test directory
    $TestDirectory = New-Item -ItemType Directory -Path "$($env:TEMP)\TestDirectory"
    
    # Create test files
    1..5 | ForEach-Object {
      New-Item -ItemType File -Path "$TestDirectory\TestFile$_.txt"
    }
  }

  AfterEach {
    # Remove test directory and all files in it
    Remove-Item -Path "$($env:TEMP)\TestDirectory" -Recurse -Force
  }

  Context 'When given a valid path and extension' {
    It 'Removes all files with the specified extension' {
      $Extension = '.txt'
      $Path = "$($env:TEMP)\TestDirectory"
      
      Remove-FilesByExtension -Path $Path -Extension $Extension -Confirm:$false
      
      $FilesLeft = Get-ChildItem -Path $Path -Recurse -Filter "*.$Extension"
      $FilesLeft | Should -BeNullOrEmpty
    }
  }
}
