function Test-Verbose {
  param (
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.PSCmdlet]
    $Cmdlet
  )
  return $Cmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent
  <#
  .SYNOPSIS
    Checks if the Verbose parameter is enabled in the current context.
  .DESCRIPTION
    The Test-Verbose function is used to check if the Verbose parameter is enabled in the current 
    context.
  .PARAMETER Cmdlet
    The current cmdlet instance.
  .EXAMPLE
    PS C:\> if (Test-Verbose -Cmdlet $MyInvocation.MyCommand) {
      Write-Verbose "Verbose output enabled."
    }

    This example shows how to use Test-Verbose to check if the Verbose parameter is enabled, and 
    write a message to the verbose output stream if it is.
  #>
}

function Test-Debug {
  param (
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.PSCmdlet]
    $Cmdlet
  )
  return $Cmdlet.MyInvocation.BoundParameters['Debug'].IsPresent
  <#
  .SYNOPSIS
    Checks if the Debug parameter is enabled in the current context.
  .DESCRIPTION
    The Test-Debug function is used to check if the Debug parameter is enabled in the current 
    context.
  .PARAMETER Cmdlet
    The current cmdlet instance.
  .EXAMPLE
    PS C:\> if (Test-Debug -Cmdlet $MyInvocation.MyCommand) {
      Write-Debug "Debug output enabled."
    }

    This example shows how to use Test-Debug to check if the Debug parameter is enabled, and write 
    a message to the debug output stream if it is.
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