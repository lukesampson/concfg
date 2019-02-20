# Usage: concfg presets
# Summary: List builtin available presets
# Help: Lists the presets that are available for the 'concfg import' command
. "$PSScriptRoot\..\lib\presets.ps1"

$presets = Get-BuiltinPreset

Write-Output "Available presets:"
Write-Output ($presets | Format-Wide { $_ } -AutoSize -Force | Out-String).Trim()
