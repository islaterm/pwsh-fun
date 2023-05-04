function Test-Verbose {
  param (
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.PSCmdlet]
    $Cmdlet
  )
  return $Cmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent
}

function Test-Regex {
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Test,
    [Parameter(Mandatory = $true)]
    [string]
    $Pattern,
    [Parameter(Mandatory = $true)]
    [string]
    $FailureMessage
  )
  if (-not ($Test -match $Pattern)) {
    throw $FailureMessage
  }
}

function Request-Confirmation {
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Caption,
    [Parameter(Mandatory = $true)]
    [string]
    $Message,
    [Parameter(Mandatory = $true)]
    [scriptblock]
    $IfTrue,
    [scriptblock]
    $IfFalse
  )
  $Choices = '&Yes', '&No'
  $Decision = $Host.UI.PromptForChoice($Caption, $Message, $Choices, 1)
  if ($Decision -eq 0) {
    $IfTrue.Invoke()
  }
  else {
    $IfFalse.Invoke()
  }
}