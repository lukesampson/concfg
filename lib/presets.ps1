function Get-BuiltinPreset {
    $presets = @()
    Get-ChildItem "$PSScriptRoot\..\presets" | ForEach-Object {
        $presets += [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    }
    return $presets
}
