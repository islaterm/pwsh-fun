# Ravenhill.FileUtils

Commands to enhance functionalities for **files and directories** for *PowerShell*.

## Remove-EmptyDirectories

Removes all empty directories in the given path.

> This command removes all empty directories in the given path using '*Robust File Copy*' 
> (`Robocopy`) as the underlying tool.

### SYNTAX

```powershell
Remove-EmptyDirectories [-Path] <String> [<CommonParameters>]
```

### PARAMETERS
- ``Path <String>`` - The path to the root of the directory tree to remove.

  |                             |                |
  | --------------------------- | -------------- |
  | Required?                   | true           |
  | Position?                   | 1              |
  | Default value               |                |
  | Accept pipeline input?      | true (ByValue) |
  | Accept wildcard characters? | false          |

### EXAMPLES

```powershell
PS> tree /f
Folder PATH listing for volume Roac
Volume serial number is 584B-A34F
C:.
│   New Text Document.txt
│
├───New folder
│   └───New folder
└───New folder (2)
PS> Remove-EmptyDirectories '.'
...
PS> tree /f
Folder PATH listing for volume Roac
Volume serial number is 584B-A34F
C:.
    New Text Document.txt

No subfolders exist
```

### RELATED LINKS

https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

## Remove-FilesByExtension

Removes files with a given extension(s) from a specified directory.

> The Remove-FilesByExtension function is used to remove all files with specified extension(s)
> from a given directory, including all subdirectories. 
> It supports the ShouldProcess functionality, which allows the user to preview the operation and 
> confirm or cancel it.
> Debug and verbose messages can also be enabled.


### SYNTAX

```powershell
Remove-FilesByExtension [-Path] <String> [-Extensions] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```	

### PARAMETERS

- ``Path <String>`` - Specifies the directory from which files with the specified extension should 
  be removed.

  |                             |                |
  | --------------------------- | -------------- |
  | Required?                   | true           |
  | Position?                   | 1              |
  | Default value               |                |
  | Accept pipeline input?      | false          |
  | Accept wildcard characters? | false          |

- ``Extensions <String[]>`` - Specifies the extension(s) of the files to be removed.

  |                             |                          |
  | --------------------------- | ------------------------ |
  | Required?                   | true                     |
  | Position?                   | 2                        |
  | Default value               |                          |
  | Accept pipeline input?      | true (ByPropertyName)    |
  | Accept wildcard characters? | false                    |

- ``WhatIf [<SwitchParameter>]`` - Shows what would happen if the cmdlet runs. The cmdlet is not run.

  |                             |                |
  | --------------------------- | -------------- |
  | Required?                   | false          |
  | Position?                   | named          |
  | Default value               |                |
  | Accept pipeline input?      | false          |
  | Accept wildcard characters? | false          |

- ``Confirm [<SwitchParameter>]`` - Prompts you for confirmation before running the cmdlet.

  |                             |                |
  | --------------------------- | -------------- |
  | Required?                   | false          |
  | Position?                   | named          |
  | Default value               |                |
  | Accept pipeline input?      | false          |
  | Accept wildcard characters? | false          |


### Examples

This example removes all files with the extension ".docx" from the directory 
``"C:\Users\John\Documents"``, including all subdirectories.

```powershell
PS C:\>Remove-FilesByExtension "C:\Users\John\Documents" -Extension "docx"
```

This example removes all files with the extensions ``.jpg`` and ``.png`` from the directory 
``C:\Users\John\Pictures``, including all subdirectories.

```powershell	
PS C:\>Remove-FilesByExtension "C:\Users\John\Pictures" -Extension "jpg","png"
```
