# Usage: concfg import [options] <preset>|<path>|<url>...
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
#   --non-interactive, -n: don't prompt for input
. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\help.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

function encode($val, $type) {
	switch($type) {
		'bool' { if($val) { 1 } else { 0 } }
		'color' {
			if($val -notmatch '^#[\da-f]{6}$') {
				write-host "ERROR: invalid color '$val', should be in hex format, e.g. #000000" -f r
				exit 1
			}
			$num = [convert]::toint32($val.substring(1,6), 16)
			$bytes = [bitconverter]::getbytes($num)
			for($i = 3; $i -gt 0; $i--) { $bytes[$i] = $bytes[$i-1] }
			$bytes[0] = 0
			[array]::reverse($bytes)
			[bitconverter]::toint32($bytes, 0)
		}
		'cursor' {
			switch($val) {
				'small'  { 0x19 }
				'medium' { 0x32 }
				'large'  { 0x64 }
				default {
					write-host "WARNING: invalid cursor_size '$val', defaulting to 'small'" -f yellow
					0x19
				}
			}
		}
		'fg_bg' {
			$fg,$bg = $val.split(',')
			if(!$fg -or !$bg) { write-host "invalid foreground,background: $val" -f red; exit 1 }
			$fg_i = $colors.indexof($fg)
			$bg_i = $colors.indexof($bg)
			if($fg_i -eq -1) { write-host "invalid foreground color: $fg" -f red; exit 1 }
			if($bg_i -eq -1) { write-host "invalid background color: $bg" -f red; exit 1 }
			$bg_i * 16 + $fg_i
		}
		'font_type' {
			if($val) { 54 } else { 0 }
		}
		'int' { $val }
		'string' { $val }
		'dim' {
			if($val -notmatch '^\d+x\d+$') { write-host "invalid dimensions '$val'" -f red; exit 1}
			$width, $height = $val.split('x') | % { [int16]::parse($_) }
			$width_b = [bitconverter]::getbytes($width)
			$height_b = [bitconverter]::getbytes($height)
			[byte[]]$bytes = @($width_b[0], $width_b[1], $height_b[0], $height_b[1])
			[bitconverter]::toint32($bytes, 0)
		}
	}
}

function preset($name) {
	if(!$name.endswith('.json')) { $name = "$name.json" }
	$x = "$psscriptroot\..\presets\$name"
	if(test-path $x) { gc $x -raw }
}

function text($src) {
	# url
	if($src -match '^https?://') { return (new-object net.webclient).downloadstring($src) }

	# local file path
	if(test-path $src) { return gc $src -raw }
	
	# preset
	preset $src
	
}

function import_json($json) {
	$props = $json | convertfrom-json

	# encode everything first before setting registry values, in case
	# anything goes wrong
	$encoded = @{}

	$props.psobject.properties | % {
		$key,$type = $reverse_map[$_.name]
		$val = $_.value
		if($key) { $encoded[$key] = (encode $val $type) }
	}

	if(!(test-path hkcu:\console)) { ni hkcu:\Console > $null } 

	$encoded.keys | % { 
		sp hkcu:\console $_ $encoded[$_]
	}
}

# flattens $args in case commas were used to separate sources
function get_sources($a) {
	$srcs = @()
	$a | % { $srcs += $_ }
	$srcs
}

$opts, $args, $err = getopt $args 'n' @('non-interactive')
if($err) { "concfg: ERROR: $err"; my_usage; exit 1 }

$non_interactive = $opts['non-interactive'] -or $opts.n

if($args.length -eq 0) { "concfg: ERROR: source missing"; my_usage; exit 1 }

$srcs = @(get_sources $args)

foreach($s in $srcs) {
	$json = text $s

	if(!$json) { "concfg: ERROR: couldn't load settings from $s"; exit 1 }

	import_json $json
	write-host "console settings were imported from $s" -f darkgreen
}

if(!$non_interactive) {
	write-host (wraptext "`noverrides in the registry and shortcut files might interfere with your concfg settings.")
	$yn = read-host "would you like to find and remove them? (Y/n)"
	if(!$yn -or ($yn -like 'y*')) {
		& "$psscriptroot\clean.ps1"
		write-host "overrides removed" -f darkgreen
	} else {
		write-host (wraptext "`nok. if you change your mind later you can run 'concfg clean' to remove overrides")
	}

	$yn = read-host "would you like to open a new console to see the changes? (Y/n)"
	if(!$yn -or ($yn -like 'y*')) { start 'powershell.exe' -arg -nologo }
} else {
	write-host (wraptext "please start a new console to see changes")
	write-host (wraptext "you may also need to run 'concfg clean' to remove overrides from the registry and shortcut files.")
}

