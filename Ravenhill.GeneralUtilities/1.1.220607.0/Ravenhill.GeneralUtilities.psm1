function Start-DelayedHibernation {
  param (
    # the time in minutes the system will wait before start hibernating.
    [Parameter(Mandatory = $true)]
    [double]
    $Minutes
  )
  Start-DelayedAction -Name 'DelayedHibernation' -Minutes $Minutes -Action {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
    $powerState = [System.Windows.Forms.PowerState]::Hibernate
    [System.Windows.Forms.Application]::SetSuspendState($powerState, $true, $false)
  }
  <#
    .SYNOPSIS
      Puts the PC into hibernation state.
    .DESCRIPTION  
      Turns the PC into hibernation mode after a certain delay.
    .NOTES
      Times lower than 1 minute can be represented as fractions.
  #>
}


function Start-DelayedSleep {
  param (
    # the time in minutes the system will wait before start sleeping.
    [Parameter(Mandatory = $true)]
    [double]
    $Minutes
  )
  Start-DelayedAction -Name 'DelayedSleep' -Minutes $Minutes -Action {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
    $powerState = [System.Windows.Forms.PowerState]::Suspend
    [System.Windows.Forms.Application]::SetSuspendState($powerState, $true, $false)
  }
  <#
    .SYNOPSIS
      Puts the PC into sleep mode.
    .DESCRIPTION  
      Turns the PC into sleep mode after a certain delay.
    .NOTES
      This function creates a background job to hold the timer.
  #>
}

function Start-DelayedShutdown {
  param (
    # the delay in minutes that the computer will wait before turning off.
    [Parameter(Mandatory = $true)]
    [double]
    $Minutes
  )
  Start-DelayedAction -Name 'DelayedShutdown' -Minutes $Minutes -Action { Stop-Computer -Force }
  <#
    .SYNOPSIS
      Turns off the pc.
    .DESCRIPTION  
      Shuts down the pc after a certain delay.
    .NOTES
      This function creates a background job to hold the timer.
  #>
}

function Start-DelayedAction {
  param (
    # The name of the job to start
    [Parameter(Mandatory = $true)]
    [string]
    $Name,
    # The delay in minutes
    [Parameter(Mandatory = $true)]
    [double]
    $Minutes,
    # The command to run
    [Parameter(Mandatory = $true)]
    [scriptblock]
    $Action
  )
  Start-Job -Name $Name -ArgumentList $Minutes, $Action -ScriptBlock {
    Start-Sleep -Seconds $($Args[0] * 60)
    [scriptblock]$script = [scriptblock]::Create($Args[1])
    Invoke-Command -ScriptBlock $script
  }
  <#
  .SYNOPSIS
    Starts a job after a certain delay.
  .DESCRIPTION
    Creates a job with a certain name and runs it after a certain delay.
  .EXAMPLE
    PS> Start-DelayedAction -Name "MyJob" -Delay 5 -Action {
    PS>   Write-Host "Hello World"
    PS> }
    PS> # After five minutes, the job will run and print "Hello World", then you can get the process
    PS> # output by running Get-Job -Name "MyJob"
    PS> Receive-Job -Name "MyJob"
    Hello World
  .NOTES
    This command will start a background job.
  #>
}

function Get-TournamentSelectionRandom {
  param (
    # The upper bound of the random number (inclusive)    
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias('hi')]
    [Int]
    $UpperBound,
    # The lower bound of the random number (defaults to 0)
    [Parameter(Position = 1)]
    [Alias('lo')]
    [Int]
    $LowerBound = 0,
    # The number of candidates from which to select (defaults to 2)
    [Parameter(Position = 2)]
    [Alias('n')]
    [Int]
    $Candidates = 2
  )
  if ($Candidates -lt 2) {
    throw "The number of candidates must be at least 2."
  }
  else {
    $best = Get-RandomBetween $LowerBound $UpperBound
    for ($i = 1; $i -lt $Candidates; $i++) {
      $best = [int]::Min($best, (Get-RandomBetween $LowerBound $UpperBound))
    }
    return $best
  }
  <#
  .SYNOPSIS
    Returns a random number between the lower and upper bounds prioritizing lower values.
  .DESCRIPTION
    Generates a given number of random numbers between the lower and upper bounds and returns the
    one closest to the lower bound.
  .EXAMPLE
    PS> Get-TournamentSelectionRandom -UpperBound 10 -Candidates 3
  .NOTES
    The bigger the number of candidates, the more likely the lower bound will be chosen.
  #>
}
Set-Alias -Name 'tsrand' -Value Get-TournamentSelectionRandom

# TODO: select boundary type
function Get-RandomBetween {
  param (
    [Parameter(Mandatory = $true)]
    [int]
    $A,
    [Parameter(Mandatory = $true)]
    [int]
    $B
  )
  if ($A -gt $B) {
    $temp = $A
    $A = $B
    $B = $temp
  }
  Get-Random -Maximum $B -Minimum $A
  <#
  .SYNOPSIS
    Returns a bounded random number with uniform distribution.
  .PARAMETER Minimum
    Lower bound.
  .PARAMETER Maximum
    Upper bound.
  #>
}
