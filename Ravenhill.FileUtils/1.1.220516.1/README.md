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

# RELATED LINKS

https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy