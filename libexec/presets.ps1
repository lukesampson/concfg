# Usage: concfg presets
# Summary: List builtin available presets
# Help: Lists the presets that are available for the 'concfg import' command

"Available presets:"
Get-ChildItem "$PSScriptRoot\..\presets" | ForEach-Object {
    "   $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))"
}
