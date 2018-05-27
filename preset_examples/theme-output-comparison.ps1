$conCfgPresetsOutput = concfg presets

$conCfgPresetOutputArr = $conCfgPresets -split " "

$conCfgPresetsArr = [System.Collections.ArrayList] @()

foreach ($word in $conCfgPresetOutputArr){
    if ($word -inotlike "" -and $word -inotlike "Available" -and $word -inotlike "presets:"){
        $conCfgPresetsArr.Add($word)
    }
}

foreach ($preset in $conCfgPresetsArr){
    concfg clean
    concfg import -n $preset
    Start-Process Powershell "-NoExit -File .\outcolors.ps1 -preset $preset"
    Start-Sleep -Seconds 3
}
