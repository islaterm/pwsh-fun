BeforeAll {
  . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'ConvertTo-Nanosecond' {
  It 'Converts a time span to nanoseconds.' {
    ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) | Should -Be 300000000000
  }
  It 'Converts a time span to nanoseconds as a string.' {
    ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsString `
    | Should -Be '00:00:00.300000000000'
  }
  It 'Converts a microsecond to nanoseconds.' {
    ConvertTo-Nanosecond -Microseconds 1 | Should -Be 1000
  }
}