# Ravenhill.GeneralUtilities

General purpose commands.

## Table of Contents

- [Ravenhill.GeneralUtilities](#ravenhillgeneralutilities)
  - [Table of Contents](#table-of-contents)
  - [Start-DelayedAction](#start-delayedaction)
    - [SYNTAX](#syntax)
    - [PARAMETERS](#parameters)
    - [NOTES](#notes)
    - [EXAMPLES](#examples)
  - [Start-DelayedHibernation / Start-DelayedSleep](#start-delayedhibernation--start-delayedsleep)
    - [SYNTAX](#syntax-1)
    - [PARAMETERS](#parameters-1)
    - [NOTES](#notes-1)
  - [Get-TournamentSelectionRandom (tsrand)](#get-tournamentselectionrandom-tsrand)
    - [SYNTAX](#syntax-2)

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
PS> Start-DelayedAction -Name "MyJob" -Delay 5 -Action {
PS>   Write-Host "Hello World"
PS> }
PS> # After five minutes, the job will run and print "Hello World", then you can get the process
PS> # output by running Get-Job -Name "MyJob"
PS> Receive-Job -Name "MyJob"
Hello World
```

## Start-DelayedHibernation / Start-DelayedSleep

Puts the PC into hibernation/sleep state.

> Turns the PC into hibernation/sleep mode after a certain delay.

### SYNTAX

```powershell
Start-DelayedHibernation [-Minutes] <Double> [<CommonParameters>]

Start-DelayedSleep [-Minutes] <Double> [<CommonParameters>]
```

### PARAMETERS

- `Minutes <Double>` - the time in minutes the system will wait before start hibernating.
  
  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | true  |
  | Position?                   | 1     |
  | Default value               | 0     |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

### NOTES

This command will start a background job.

Times lower than 1 minute can be represented as fractions.

## Get-TournamentSelectionRandom (tsrand)
  
Returns a random number between the lower and upper bounds prioritizing lower values.

> Generates a given number of random numbers between the lower and upper bounds and returns the
> one closest to the lower bound.

### SYNTAX
```powershell
Get-TournamentSelectionRandom [-UpperBound] <Int32> [[-LowerBound] <Int32>] [[-Candidates] <Int32>] [<CommonParameters>]
```	

### PARAMETERS
- `UpperBound <Int32>` - The upper bound of the random number (inclusive)

|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | 1     |
| Default value               | 0     |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

- `LowerBound <Int32>` - The lower bound of the random number (defaults to 0)

|                             |       |
| --------------------------- | ----- |
| Required?                   | false |
| Position?                   | 2     |
| Default value               | 0     |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

- `Candidates <Int32>` - The number of candidates from which to select (defaults to 2)

|                             |       |
| --------------------------- | ----- |
| Required?                   | false |
| Position?                   | 3     |
| Default value               | 2     |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

### NOTES

The bigger the number of candidates, the more likely the lower bound will be chosen.

### EXAMPLES
```powershell
PS> Get-TournamentSelectionRandom -UpperBound 10 -Candidates 3
```