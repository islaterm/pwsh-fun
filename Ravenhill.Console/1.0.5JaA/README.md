# Ravenhill.Console

This module contains utility functions to manage powershell consoles.

## Reset-PowershellConsole

Opens a new PowerShell console and closes the current one.

Uses the *Conemu* functions to create a new console and close the current one, with admin
privileges if the ``$Admin`` flag is given.

### SYNTAX

```powershell
Reset-PowershellConsole [-Admin] [<CommonParameters>]
```

### PARAMETERS

- ``Admin [<SwitchParameter>]`` - If present, then opens an elevated PS console.
  - **Required?** - false
  - **Position?** - named
  - **Default value** - False
  - **Accept pipeline input?** - false
  - **Accept wildcard characters?** - false

### Examples
```powershell
# Closes the current console and starts a new one with elevated privileges.
PS> Reset-PowershellConsole -Admin
```

