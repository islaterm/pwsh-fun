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
