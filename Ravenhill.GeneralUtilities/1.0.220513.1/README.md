# Ravenhill.GeneralUtilities

General purpose commands.

## Set-DelayedHibernation

Puts the PC into hibernation state.

Turns the PC in hibernation mode after a certain delay.

### SYNTAX

```powershell
Set-DelayedHibernation [-Delay] <Int32> [<CommonParameters>]
```

### PARAMETERS
- `Delay <Int32>` - the time in seconds the system will wait before start hibernating.
  
  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | true  |
  | Position?                   | 1     |
  | Default value               | 0     |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

### NOTES

This command will freeze the console, if you want it to run in the background,
you'll have to
run it in a separate process.

## Start-DelayedAction

Starts a job after a certain delay.

Creates a job with a certain name and runs it after a certain delay.

### SYNTAX

```powershell
Start-DelayedAction [-Name] <String> [-Delay] <Double> [-Action] <ScriptBlock> [<CommonParameters>]
```

### PARAMETERS

- `Name <String>` - The name of the job to start
  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | true  |
  | Position?                   | 1     |
  | Default value               |       |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

- `Delay <Double>` - The delay in minutes
  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | true  |
  | Position?                   | 2     |
  | Default value               | 0     |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

- `Action <ScriptBlock>` - The command to run
  
  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | true  |
  | Position?                   | 3     |
  | Default value               |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

### NOTES

This command will start a background job.

### EXAMPLES
```powershell
  PS>Start-DelayedAction -Name "MyJob" -Delay 5 -Action {
  PS>   Write-Host "Hello World"
  PS> }
  PS> # After five minutes, the job will run and print "Hello World", then you can get the process
  PS> # output by running Get-Job -Name "MyJob"
  PS> Receive-Job -Name "MyJob"
  Hello World
  ```