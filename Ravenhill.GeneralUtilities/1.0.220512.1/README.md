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