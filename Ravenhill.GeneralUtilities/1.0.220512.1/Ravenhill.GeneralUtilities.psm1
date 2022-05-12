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