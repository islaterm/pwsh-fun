function Set-ErrorActionPreference {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [ValidateSet('Continue', 'Inquire', 'SilentlyContinue', 'Stop', 'Suspend')]
    [string]
    $Preference
  )
  $originalErrorActionPreference = $ErrorActionPreference
  Write-Verbose "Setting ErrorActionPreference to $Preference"
  $ErrorActionPreference = $Preference
  return $originalErrorActionPreference
  <#
  .SYNOPSYS
    Set the error action preference.
  .DESCRIPTION
    Set the error action preference to the specified value and return the original value.
  #>
}
