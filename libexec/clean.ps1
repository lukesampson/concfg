# Usage: concfg clean
# Summary: Clean overrides from the registry and .lnk files
# Help: Cleans any program-specific overrides from the registry.
#
# Background: The Console will save program-specific overrides to
# the registry and sometimes shortcut files when you edit
# the console properties directly. These overrides can
# prevent your concfg settings from working properly.
# Using concfg clean can remove all these overrides.
. "$PSScriptRoot\..\lib\shortcut.ps1"

function Clear-AllOverride {
    # 1. clean console registry
    if (Test-Path 'HKCU:\Console') {
        Get-ChildItem 'HKCU:\Console' | ForEach-Object {
            Write-Output "Removing 'Registry::$($_.Name)'"
            Remove-Item "Registry::$($_.Name)"
        }
    }

    # 2. clean powershell .lnk files
    @(
        "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs",
        "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu",
        "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar",
        "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
    ) | ForEach-Object { Reset-PowerShellShortcut $_ }
}

# entry
Clear-AllOverride
