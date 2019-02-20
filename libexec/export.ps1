# Usage: concfg export [path]
# Summary: Export console settings as JSON
# Help: If a file path is supplied, your console settings will be written directly to it.
#
# If no path is supplied, writes the settings to standard output.
Param($path)

function decode($val, $type) {
    switch($type) {
        'bool' { [bool]$val }
        'color' {
            $bytes = [bitconverter]::getbytes($val)
            [array]::reverse($bytes)
            $int = [bitconverter]::toint32($bytes, 0)

            '#' + $int.tostring('x8').substring(0,6)
        }
        'cursor' {
            switch($val) {
                0x19 { 'small' }
                0x32 { 'medium' }
                0x64 { 'large' }
            }
        }
        'fg_bg' {
            $hex = $val.tostring('x2')
            $bg_i = [convert]::toint32($hex[0],16)
            $fg_i = [convert]::toint32($hex[1],16)
            $bg = $colors[$bg_i]
            $fg = $colors[$fg_i]
            "$fg,$bg"
        }
        'font_type' { ($val -gt 0) }
        'int' { $val }
        'string' { $val }
        'dim' {
            $bytes = [bitconverter]::getbytes($val)
            $width = [bitconverter]::toint16($bytes[0..2], 0)
            $height = [bitconverter]::toint16($bytes, 2)
            "$($width)x$($height)"
        }
    }
}

function export_json {
    $props = @{}
    (Get-ItemProperty 'HKCU:\Console').PSObject.Properties | Sort-Object name | ForEach-Object {
        $name, $type = $map[$_.Name]
        if ($name) {
            $props.Add($name, (decode $_.Value $type))
        }
    }

    $props | ConvertTo-Json
}

$json = export_json
if ($path) {
    $json | Out-File $path -Encoding utf8
    Write-Host "console settings exported to $(Split-Path $path -Leaf)" -f DarkGreen
} else {
    $json
}
