# Ravenhill.UserUtilities

User utility commands for PowerShell.

## Table of Contents

- [Ravenhill.UserUtilities](#ravenhilluserutilities)
  - [Table of Contents](#table-of-contents)
  - [Set-EnvironmentVariable](#set-environmentvariable)
    - [SYNTAX](#syntax)
    - [PARAMETERS](#parameters)
    - [NOTES](#notes)
    - [EXAMPLES](#examples)


## Set-EnvironmentVariable

Sets an environment variable.

> Sets a new or existing environment variable as a key-value pair with a given scope.

    -------------------------- EXAMPLE 1 --------------------------

    PS>Set-EnvironmentVariable -Machine -Key "MyKey" -Value "MyValue"
    PS> Update-SessionEnvironment
    PS> Write-Host "MyKey: $env:MyKey"
    MyKey: MyValue






    -------------------------- EXAMPLE 2 --------------------------

    PS>Get-Location | Set-EnvironmentVariable -User -Key "DEV_WORKSPACE"
### SYNTAX
  
```powershell
Set-EnvironmentVariable -Value <String> -Key <String> -User [<CommonParameters>]

Set-EnvironmentVariable -Value <String> -Key <String> -Machine [<CommonParameters>]
```

### PARAMETERS

- ``Value <String>`` - The value of the environment variable to set.

|                             |                |
| --------------------------- | -------------- |
| Required?                   | true           |
| Position?                   | named          |
| Default value               |                |
| Accept pipeline input?      | true (ByValue) |
| Accept wildcard characters? | false          |

- ``Key <String>`` - The name of the environment variable to set.
  
|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | named |
| Default value               |       |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

- ``User [<SwitchParameter>]`` - Designates the current user as the owner of the environment 
  variable.
  
|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | named |
| Default value               | False |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |
    
- ``Machine [<SwitchParameter>]`` - Designates the current machine as the owner of the environment 
  variable.
  
|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | named |
| Default value               | False |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

### NOTES

This change is persistent across sessions.

### EXAMPLES

```powershell
PS> Set-EnvironmentVariable -Key "MyKey" -Value "MyValue" -User
PS> Update-SessionEnvironment
PS> Write-Host "MyKey: $env:MyKey"
MyKey: MyValue
```

```powershell	
PS> Set-EnvironmentVariable -Machine -Key "MyKey" -Value "MyValue"
```

```powershell
PS> Get-Location | Set-EnvironmentVariable -User -Key "DEV_WORKSPACE"
```