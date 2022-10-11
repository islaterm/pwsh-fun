function ConvertTo-Nanosecond {
  [CmdletBinding()]
  param (
    # The time span to convert to nanoseconds.
    [Parameter(Mandatory, ParameterSetName = 'TimeSpan')]
    [TimeSpan]
    $TimeSpan,
    # The microseconds to convert to nanoseconds.
    [Parameter(Mandatory, ParameterSetName = 'Microsecond')]
    [Int]
    $Microsecond,
    # If specified, the result will be returned as a timestamp string.
    [switch]
    $AsTimestamp,
    # If specified, the result will be returned as a string.
    [switch]
    $AsString
  )
  process {
    $nanoseconds = 0
    switch ($PSCmdlet.ParameterSetName) {
      'TimeSpan' {
        $nanoseconds = $TimeSpan.TotalSeconds * 1e9
        if ($AsTimestamp) {
          $nanoseconds = "00:00:00.$nanoseconds"
        }
      }
      'Microsecond' {
        $microsecond
        $nanoseconds = $DateTime.Ticks * 1e6
      }
    }
    return $nanoseconds
  }
  <#
  .SYNOPSIS
    Converts a time span to nanoseconds.
  .DESCRIPTION
    Converts a time span to nanoseconds.
  .EXAMPLE
    PS> ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5)
    300000000000
  .EXAMPLE
    PS> ConvertTo-Nanosecond -TimeSpan (New-TimeSpan -Minutes 5) -AsTimeSpan
    00:00:00.300000000000
    0
  #>
}