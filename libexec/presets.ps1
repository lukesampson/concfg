# Usage: concfg presets
# Summary: List builtin available presets
# Help: Lists the presets that are available for the 'concfg import' command
. "$PSScriptRoot\..\lib\presets.ps1"

$result = Get-BuiltinPreset

Write-Output "Available presets:"
Format-PresetOutput($result)
