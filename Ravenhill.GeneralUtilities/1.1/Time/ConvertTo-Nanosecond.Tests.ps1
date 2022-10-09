. "$PSScriptRoot\ConvertTo-Nanosecond.ps1"

Describe 'ConvertTo-Nanosecond' {
  It 'Converts a time span to nanoseconds.' {
    ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) | Should Be 300000000000
  }
}