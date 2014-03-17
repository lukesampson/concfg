# Usage: concfg export [path]
# Summary: Export console settings as JSON
# Help: If a file path is supplied, your console settings will be written directly to it.
#
# If no path is supplied, writes the settings to standard output.
param($path)

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
	(gp hkcu:\console).psobject.properties | sort name |% {
		$name,$type = $map[$_.name]
		if($name) {
			$props.add($name, (decode $_.value $type))
		}
	}

	$props | convertto-json
}

$json = export_json
if($path) {
	$json | out-file $path -encoding utf8
	write-host "console settings exported to $(split-path $path -leaf)" -f darkgreen
}
else { $json }