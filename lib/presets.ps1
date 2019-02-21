function Get-BuiltinPreset {
    $presets = @()
    Get-ChildItem "$PSScriptRoot\..\presets" | ForEach-Object {
        $presets += [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    }
    return $presets
}

function Format-PresetOutput($presets) {
    Write-Output ($presets | Format-Wide { $_ } -AutoSize -Force | Out-String).Trim()
}
