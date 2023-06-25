function Test-Verbose {
  param (
    # Specifies a hashtable containing the parameters to be tested.
    [Parameter(Mandatory, HelpMessage = "A hashtable containing the parameters to be tested.")]
    [hashtable]
    $Parameters
  )
  $Parameters.ContainsKey('Verbose')
  <#
  .SYNOPSIS
    Checks if the Verbose parameter is enabled in the current context.
  .DESCRIPTION
    The Test-Verbose function is used to check if the Verbose parameter is enabled in the current 
    context.
  .EXAMPLE
    In this example, we use Test-Verbose to check if the Verbose parameter is enabled.

    PS> $params = @{
    PS>   Verbose = $true
    PS> }
    PS> Test-Verbose -Parameters $params
    True
  #>
}

function Test-Debug {
  param(
    # Specifies a hashtable containing the parameters to be tested.
    [Parameter(Mandatory, HelpMessage = "A hashtable containing the parameters to be tested.")]
    [hashtable]
    $Parameters
  )
  $Parameters.ContainsKey('Debug')
  <#
  .SYNOPSIS
    Checks if the Debug parameter is enabled in the current context.
  .DESCRIPTION
    The Test-Debug function is used to check if the Debug parameter is enabled in the current 
    context.
  .EXAMPLE
    In this example, we use Test-Debug to check if the Debug parameter is enabled.

    PS> $params = @{
    PS>   Debug = $true
    PS> }
    PS> Test-Debug -Parameters $params
    True
  #>
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