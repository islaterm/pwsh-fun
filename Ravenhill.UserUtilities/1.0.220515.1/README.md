# Ravenhill.UserUtilities

User utility commands for PowerShell.

## Table of Contents

- [Ravenhill.UserUtilities](#ravenhilluserutilities)
  - [Table of Contents](#table-of-contents)
  - [Set-UserEnvironmentVariable](#set-userenvironmentvariable)
    - [SYNTAX](#syntax)
    - [PARAMETERS](#parameters)
    - [NOTES](#notes)
    - [EXAMPLES](#examples)


## Set-UserEnvironmentVariable

Sets an environment variable for the current user.

> Sets a new or existing environment variable as a key-value pair for the current user as scope.

### SYNTAX
  
```powershell
Set-UserEnvironmentVariable [-Key] <String> [-Value] <String> [<CommonParameters>]
```

### PARAMETERS
- ``Key <String>`` - The name of the environment variable to set.
  
|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | 1     |
| Default value               |       |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

- ``Value <String>`` - The value of the environment variable to set.

|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | 2     |
| Default value               |       |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

### NOTES

This change is persistent across sessions.

### EXAMPLES

```powershell
PS>Set-UserEnvironmentVariable -Key "MyKey" -Value "MyValue"
PS> Update-SessionEnvironment
PS> Write-Host "MyKey: $env:MyKey"
MyKey: MyValue
```