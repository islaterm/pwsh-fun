function ConvertTo-H265 {
    [CmdletBinding()]
    param()
    begin {
        $ffmpeg = Get-Command -Name ffmpeg -ErrorAction SilentlyContinue
        if (-not $ffmpeg) {
            throw 'ffmpeg is not installed'
        }
    }
}