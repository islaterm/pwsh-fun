Import-Module Ravenhill.ScriptUtils

function ConvertTo-MP3 {
  [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Path,

        [Parameter(Mandatory)]
        [string]
        $Format
    )
    begin {
        Write-Verbose "Converting all '$Format' files in '$Path' to mp3 using ffmpeg"
    }
    process {
        $resolvedPath = Resolve-Path $Path
        $filesToConvert = Get-ChildItem -Path $resolvedPath -Recurse -File -Filter "*.$Format"

        foreach ($file in $filesToConvert) {
            $outputPath = Join-Path $file.Directory.FullName ($file.BaseName + '.mp3')
            $arguments = "-i `"$($file.FullName)`" `"$outputPath`""
            $command = "ffmpeg.exe $arguments"
            Write-Verbose "Converting '$($file.FullName)' to '$($outputPath)'"
            Invoke-Expression $command
        }
    }
    end {
        Write-Verbose "Finished converting all '$Format' files in '$Path' to mp3"
    }
    <#
    .SYNOPSIS
        Converts all files of the given format of a directory to mp3 using ffmpeg.
    .DESCRIPTION
        The Convert-FilesToMp3 function converts all files of a given format in a directory to mp3 
        using ffmpeg.
    .EXAMPLE
        PS C:\> Convert-FilesToMp3 -Path "C:\Users\John\Documents" -Format "wav"
        This example converts all files with the format ".wav" in the directory 
        "C:\Users\John\Documents", including all subdirectories, to mp3 format using ffmpeg.
    .LINK
        https://www.ffmpeg.org/
    #>
}
