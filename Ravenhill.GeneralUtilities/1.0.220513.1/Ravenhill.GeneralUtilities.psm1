[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

function Set-DelayedHibernation {
  param (
    [Parameter(Mandatory = $true)]
    [int]
    $Delay
  )
  $powerState = [System.Windows.Forms.PowerState]::Hibernate
  $delayInSeconds = $delay * 60
  Start-Sleep -s $delayInSeconds
  [System.Windows.Forms.Application]::SetSuspendState($powerState, $true, $false)
  <#
    .SYNOPSIS
      Puts the PC into hibernation state.
    .DESCRIPTION  
      Turns the PC in hibernation mode after a certain delay.
    .PARAMETER delay
      the time in seconds the system will wait before start hibernating.
    .NOTES
      This command will freeze the console, if you want it to run in the background, you'll have to 
      run it in a separate process.
  #>
}


function Set-DelayedSleep ([double] $delay) {
  $powerState = [System.Windows.Forms.PowerState]::SetSuspendState
  $delayInSeconds = $delay * 60
  Start-Sleep -s $delayInSeconds
  [System.Windows.Forms.Application]::SetSuspendState($powerState, $true, $false)
  <#
    .SYNOPSIS
      Puts the PC into hibernation state.
    .DESCRIPTION  
      Turns the PC in hibernation mode after a certain delay
    .PARAMETER delay
      the time in seconds the system will wait before start hibernating
  #>
}

function Set-DelayedShutdown ([double] $delay) {
  $delayInSeconds = $delay * 60
  Start-Sleep -s $delayInSeconds
  Stop-Computer -Force
  <#
    .SYNOPSIS
      Turns off the pc.
    .DESCRIPTION  
      Shuts down the pc after a certain delay
    .PARAMETER delay
      the time in seconds the system will wait before shutting down
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
    $Delay,
    # The command to run
    [Parameter(Mandatory = $true)]
    [scriptblock]
    $Action
  )
  Start-Job -Name $Name -ArgumentList $Delay, $Action -ScriptBlock {
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