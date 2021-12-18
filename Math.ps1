function Ceil {
  param (
    [double]
    $x
  )
  [math]::Ceiling($x)
  <#
    .SYNOPSIS
      Calculates the ceiling of a number.
    .DESCRIPTION
      For any x returns the closest integer that's greater or equal than x
    .PARAMETER x
      The numbre for which the ceiling is gonna be calculated.
  #>
}