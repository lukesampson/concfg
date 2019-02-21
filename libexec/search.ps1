# Usage: concfg search <preset>
# Summary: Search builtin presets with given preset name
Param($preset)
. "$PSScriptRoot\..\lib\help.ps1"
. "$PSScriptRoot\..\lib\presets.ps1"

if (!($preset)) {
    my_usage
    exit 1
}

$builtinPresets = Get-BuiltinPreset
$result = @()

$builtinPresets | ForEach-Object {
    if ($_ -match "$preset") {
        $result += $_
    }
}

if ($result) {
    Format-PresetOutput($result)
} else {
    Write-Output "No preset name is similar to '$preset'."
}
