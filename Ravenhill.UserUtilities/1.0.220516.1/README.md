# Ravenhill.UserUtilities

User utility commands for PowerShell.

## Table of Contents

- [Ravenhill.UserUtilities](#ravenhilluserutilities)
  - [Table of Contents](#table-of-contents)
  - [Set-EnvironmentVariable (seetenv)](#set-environmentvariable-seetenv)
    - [SYNTAX](#syntax)
    - [PARAMETERS](#parameters)
    - [NOTES](#notes)
    - [EXAMPLES](#examples)
  - [Get-HomeDirectory (~) / Set-HomeDirectory](#get-homedirectory---set-homedirectory)
    - [SYNTAX](#syntax-1)
    - [PARAMETERS](#parameters-1)
    - [INPUTS](#inputs)
    - [OUTPUTS](#outputs)
    - [EXAMPLES](#examples-1)


## Set-EnvironmentVariable (seetenv)

Sets an environment variable.

> Sets a new or existing environment variable as a key-value pair with a given scope.

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
  Alias: `u`
  
|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | named |
| Default value               | False |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |
    
- ``Machine [<SwitchParameter>]`` - Designates the current machine as the owner of the environment 
  variable.
  Alias: `m`
  
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

```powershell
PS> # Note the order of the parameters in this call since it's using positional values
PS> ls | setenv 'DEV_WORKSPACE' -u # This yields the same result as the previous example
```

## Get-HomeDirectory (~) / Set-HomeDirectory

Get/Set the home directory of the current user.

> ``Set-HomeDirectory`` - Registers the `$Env:USER_HOME_DIR` environment variable to the given path 
> as the home directory of the current user.

> ``Get-HomeDirectory`` - Retrieves the value set for the `$Env:USER_HOME_DIR` environment variable.

### SYNTAX

```powershell	
Set-HomeDirectory [-Path] <String> [<CommonParameters>]
Get-HomeDirectory [<CommonParameters>]
```

### PARAMETERS
- ``Path <String>`` - The path to the home directory to set.

|                             |       |
| --------------------------- | ----- |
| Required?                   | true  |
| Position?                   | 1     |
| Default value               |       |
| Accept pipeline input?      | false |
| Accept wildcard characters? | false |

### INPUTS

**Set:** The path to the home directory.

### OUTPUTS

**Get:** The path to the home directory.

### EXAMPLES

```powershell	
PS> Set-HomeDirectory -Path "C:\Users\MyUser"
PS> Get-HomeDirectory
C:\Users\MyUser
```	

```powershell	
PS> Get-HomeDirectory | Write-Host
C:\Users\MyUser
```	

```powershell	
PS> Get-HomeDirectory | Set-Location
PS> Get-Location | Write-Host
C:\Users\MyUser
```

```powershell	
PS> cd ~
PS> Get-Location | Write-Host # This yields the same result as the previous example
C:\Users\MyUser
```	