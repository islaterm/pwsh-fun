BeforeAll {
  . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'ConvertTo-Nanosecond' {
  It 'Converts a time span to nanoseconds.' {
    ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) | Should -Be 300000000000
  }
  It 'Converts a time span to nanoseconds as a time span.' {
    ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsTimeSpan `
    | Should -Be '00:00:00.3000000'
  }
  It 'Converts a time span to nanoseconds as a double.' {
    ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsDouble | Should -Be 0.3
  }
  It 'Converts a time span to nanoseconds as an integer.' {
    ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsInt | Should -Be 0
  }
}