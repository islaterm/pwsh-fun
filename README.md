# Pwsh-Fun

Because PowerShell can be fun (at least that's what I tell myself).
Here are some utility functions that can help you to use the Power of your Shell.

## ConvertTo-Mp3

Converts a list of files to mp3.

Makes a conversion of all valid audio files of a directory to .mp3 extension using _ffmpeg_.

### SYNTAX
```powershell
ConvertTo-MP3 [-Path] <String> [-Cleanup] [<CommonParameters>]
```
Using the ``Cleanup`` flag will delete the original audio files if the conversion was successful.

## Ceil

Calculates the ceiling of a number.

For any _x_ returns the **closest integer** that's **greater or equal** than _x_.

### SYNTAX
```powershell
Ceil [[-x] <Double>] [<CommonParameters>]
```

## Invoke-GradleRun

Invokes a `gradle run` Task and waits for it to finish it's execution.
### SYNTAX

```powershell
Invoke-GradleRun [-Path] <String> [[-Arguments] <String[]>] [<CommonParameters>]
```
#### PARAMETERS 
- ``Path``: The path to a folder containing a ``gradle.build`` or ``gradle.build.kts`` file.

### EXAMPLES

```powershell
function Some-Function {
  Invoke-GradleRun -Path 'C:\Some\Function\Path\GradleProject' $Args
}
```

## Test-Command

Checks if a command exists.

### SYNTAX

```powershell
Test-Command [-Command] <String> [<CommonParameters>]
```
#### PARAMETERS
```powershell
-Command <String>
  The name of the command to check.
```

#### Examples
```powershell
PS> Test-Command winget
True
```
---
```powershell
PS> Test-Command julia
False
```
---
```powershell
PS> 'julia' | Test-Command
False
```

## Test-Application

Checks if an application is installed on the system.


### SYNTAX
```powershell
Test-Application [[-Name] <String>] [<CommonParameters>]

Test-Application [-DisplayName] <String> [<CommonParameters>]
```

### PARAMETERS

```powershell
-DisplayName <String>
    The display name of the application.

-Name <String>
    The name of the process that identifies the application.
```

### Examples

```powershell
PS> Test-Application 'NVIDIA Web Helper.exe'
# True if the service NVIDIA Web Helper is registered, False otherwise
```

---

```powershell
PS> Test-Application -Name '7-zip'
# True if 7-zip is installed, false otherwise
```

---
```powershell
PS> Test-Application -DisplayName '3Tene'
# True if 3Tene is installed, regardless of the installation method
# (If using Steam this could have been registered with a 'Name' like Steam App XXXXXX)
```