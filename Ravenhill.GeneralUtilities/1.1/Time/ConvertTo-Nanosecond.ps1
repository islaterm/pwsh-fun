function ConvertTo-Nanosecond {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [TimeSpan]
    $TimeSpan
  )
  
  begin {
    
  }
  
  process {
    
  }
  
  end {
    
  }
  <#
  .SYNOPSIS
    Converts a time span to nanoseconds.
  .DESCRIPTION
    Converts a time span to nanoseconds.
  .PARAMETER TimeSpan
    The time span to convert.
  .EXAMPLE
    PS> ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5)
    300000000000
  .EXAMPLE
    PS> ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsTimeSpan
    00:00:00.3000000
  .EXAMPLE
    PS> ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsTimeSpan -AsDouble
    0.3
  .EXAMPLE
    PS> ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsTimeSpan -AsDouble -AsInt
    0
  #>
}