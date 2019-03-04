# Usage: concfg import [options] <preset>|<path>|<url>
# Summary: Import console settings from a JSON file
# Help: e.g. concfg import solarized
#
# You can import multiple sources at once, e.g.
#     concfg import solarized-light small
#
# This will import the 'solarized-light' preset and the 'small' preset.
# When importing multiple sources, the later sources will override settings
# from the earlier ones.
#
# Options:
#   -n, --non-interactive  don't prompt for input
#   -y, --yes              accpet prompts automatically
. "$PSScriptRoot\..\lib\core.ps1"
. "$PSScriptRoot\..\lib\help.ps1"
. "$PSScriptRoot\..\lib\getopt.ps1"
. "$PSScriptRoot\..\lib\presets.ps1"

function encode($val, $type) {
    switch($type) {
        'bool' {
            if ($val) {
                1
            } else {
                0
            }
        }
        'color' {
            if ($val -notmatch '^#[\da-f]{6}$') {
                Write-Host "ERROR: invalid color '$val', should be in hex format, e.g. #000000" -f DarkRed
                exit 1
            }
            $num = [System.Convert]::ToInt32($val.Substring(1,6), 16)
            $bytes = [System.BitConverter]::GetBytes($num)
            for ($i = 3; $i -gt 0; $i--) {
                $bytes[$i] = $bytes[$i - 1]
            }
            $bytes[0] = 0
            [Array]::Reverse($bytes)
            [System.BitConverter]::ToInt32($bytes, 0)
        }
        'cursor' {
            switch($val) {
                'small'  { 0x19 }
                'medium' { 0x32 }
                'large'  { 0x64 }
                default {
                    Write-Host "WARNING: invalid cursor_size '$val', defaulting to 'small'" -f DarkYellow
                    0x19
                }
            }
        }
        'fg_bg' {
            $fg,$bg = $val.Split(',')
            if (!$fg -or !$bg) {
                Write-Host "invalid foreground,background: $val" -f DarkRed
                exit 1
            }
            $fg_i = $colors.IndexOf($fg)
            $bg_i = $colors.IndexOf($bg)
            if ($fg_i -eq -1) {
                Write-Host "invalid foreground color: $fg" -f DarkRed
                exit 1
            }
            if ($bg_i -eq -1) {
                Write-Host "invalid background color: $bg" -f DarkRed
                exit 1
            }
            $bg_i * 16 + $fg_i
        }
        'font_type' {
            if ($val) {
                54
            } else {
                0
            }
        }
        'int' {
            $val
        }
        'string' {
            $val
        }
        'dim' {
            if ($val -notmatch '^\d+x\d+$') {
                Write-Host "invalid dimensions '$val'" -f DarkRed
                exit 1
            }
            $width, $height = $val.Split('x') | ForEach-Object {
                [Int16]::Parse($_)
            }
            $width_b = [System.BitConverter]::GetBytes($width)
            $height_b = [System.BitConverter]::GetBytes($height)
            [Byte[]]$bytes = @($width_b[0], $width_b[1], $height_b[0], $height_b[1])
            [System.BitConverter]::ToInt32($bytes, 0)
        }
    }
}

function Get-PresetJson($src) {
    # remote preset file url
    if ($src -match '^https?://') {
        return (New-Object System.Net.WebClient).DownloadString($src)
    }

    # local preset file path
    if ((Test-Path $src) -and $src.EndsWith('.json')) {
        return Get-Content $src -Raw
    }

    # built-in preset
    if (!$src.EndsWith('.json')) {
        $builtinPresets = Get-BuiltinPreset
        if ($builtinPresets.Contains($src)) {
            return Get-Content "$PSScriptRoot\..\presets\$src.json" -Raw
        }
    }
}

function Import-PresetFromJson($json) {
    $props = $json | ConvertFrom-Json

    # encode everything first before setting registry values, in case
    # anything goes wrong
    $encoded = @{}

    $props.PSObject.Properties | ForEach-Object {
        $key, $type = $reverse_map[$_.Name]
        $val = $_.Value
        if ($key) {
            $encoded[$key] = (encode $val $type)
        }
    }

    if (!(Test-Path 'HKCU:\Console')) {
        New-Item 'HKCU:\Console' | Out-Null
    }

    $encoded.Keys | ForEach-Object {
        Set-ItemProperty 'HKCU:\Console' $_ $encoded[$_]
    }
}

# flattens $args in case commas were used to separate sources
function get_sources($inputArgs) {
    $sources = @()
    $inputArgs | ForEach-Object {
        $sources += [String]$_
    }
    return $sources
}

# entry
$opts, $args, $err = getopt $args 'yn' @('yes', 'non-interactive')
$optNonInteractive = $opts['non-interactive'] -or $opts.n
$optYes = $opts['yes'] -or $opts.y

if ($err) {
    Write-Output "concfg: ERROR: $err"
    my_usage
    exit 1
}

if ($args.length -eq 0) {
    Write-Output "concfg: ERROR: source missing"
    my_usage
    exit 1
}

$srcs = @(get_sources $args)
foreach ($source in $srcs) {
    $json = Get-PresetJson $source
    if (!$json) {
        Write-Output "concfg: ERROR: couldn't load settings from $source"
        exit 1
    }

    Import-PresetFromJson $json
    Write-Host "Console settings were imported from '$source'" -f DarkGreen
}

if (!$optNonInteractive) {
    if ($optYes) {
        & "$PSScriptRoot\clean.ps1"
        if ($PSVersionTable.PSEdition -eq 'Core') {
            Start-Process "$PSHOME\pwsh.exe" -ArgumentList "-NoLogo"
        } else {
            Start-Process "powershell.exe" -ArgumentList "-NoLogo"
        }
    } else {
        $yn = Read-Host "Overrides in the registry and shortcut files might interfere with your concfg settings. Would you like to find and remove them? (Y/n)"
        if (!$yn -or ($yn -like 'y*')) {
            & "$PSScriptRoot\clean.ps1"
        } else {
            Write-Output "If you change your mind later you can run 'concfg clean' to remove overrides."
        }

        $yn = Read-Host "`nWould you like to open a new console to see the changes? (Y/n)"
        if (!$yn -or ($yn -like 'y*')) {
            if ($PSVersionTable.PSEdition -eq 'Core') {
                Start-Process "$PSHOME\pwsh.exe" -ArgumentList "-NoLogo"
            } else {
                Start-Process "powershell.exe" -ArgumentList "-NoLogo"
            }
        }
    }
} else {
    Write-Output "Please start a new console to see changes."
    Write-Output "You may also need to run 'concfg clean' to remove overrides from the registry and shortcut files."
}
