param($cmd)

$usage = "usage:
	concfg import <preset>|<path>|<url>
	concfg export <path>
	concfg clean"

# registry reference:
#     http://technet.microsoft.com/en-us/library/cc978570.aspx
#
# setting NT_CONSOLE_PROPS (not implemented):
#     http://sourcewarp.blogspot.com.au/2012/06/windows-powershell-shortcut-ishelllink.html

$colors = 'black,dark_blue,dark_green,dark_cyan,dark_red,dark_magenta,dark_yellow,gray,dark_gray,blue,green,cyan,red,magenta,yellow,white'.split(',')

$map = @{
	'FontFamily'=@('font_true_type', 'font_type')
	'FaceName'=@('font_face', 'string')
	'FontSize'=@('font_size', 'dim')
	'FontWeight'=@('font_weight','int')
	'CursorSize'=@('cursor_size','cursor')
	'QuickEdit'=@('quick_edit', 'bool')
	'ScreenBufferSize'=@('screen_buffer_size', 'dim')
	'WindowSize'=@('window_size', 'dim')
	'PopupColors'=@('popup_colors', 'fg_bg')
	'ScreenColors'=@('screen_colors', 'fg_bg')
	'FullScreen'=@('fullscreen','bool')
	'HistoryBufferSize'=@('command_history_length','int')
	'NumberOfHistoryBuffers'=@('num_history_buffers','int')
	'InsertMode'=@('insert_mode','bool')
	'LoadConIme'=@('load_console_IME','bool')
}
for($i=0;$i -lt $colors.length;$i++) {
	$map.add("ColorTable$($i.tostring('00'))", @($colors[$i],'color'))
}
$reverse_map = @{}
foreach($key in $map.keys) {
	$name,$type = $map[$key]
	$reverse_map.add($name, @($key,$type))
}

function export {
	$props = @{}
	(gp hkcu:\console).psobject.properties | sort name |% {
		$name,$type = $map[$_.name]
		if($name) {
			$props.add($name, (decode $_.value $type))
		}
	}

	$props | convertto-json
}

function import($json) {
	$props = $json | convertfrom-json

	# encode everything first before setting registry values, in case
	# anything goes wrong
	$encoded = @{}

	$props.psobject.properties | % {
		$key,$type = $reverse_map[$_.name]
		$val = $_.value
		if($key) { $encoded[$key] = (encode $val $type) }
	}

	$encoded.keys | % { 
		sp hkcu:\console $_ $encoded[$_]
	}
}

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
			"$([bitconverter]::toint32($bytes, 0))"
		}
	}
}

function preset($name) {
	if(!$name.endswith('.json')) { $name = "$name.json" }
	$x = "$($myinvocation.psscriptroot)\presets\$name"
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

function clean {
	gci hkcu:console | % { rm "registry::$($_.name)" }
}

function import_cmd($src) {
	if(!$src) { "ERROR: source missing"; $usage; exit 1 }
	$settings = text $src

	if(!$settings) { "ERROR: couldn't load settings from $src"; exit 1 }

	import $settings
	write-host "console settings were imported from $src" -f darkgreen
	write-host "
*** note: if you start a new console from a shortcut (.lnk), it may override
          your concfg settings.
"

	if(gci hkcu:console) {
		write-host "
there are program-specific overrides in the registry that might interfere with
your concfg settings." -f darkyellow
		$yn = read-host "would you like to remove them? (Y/n)"
		if(!$yn -or ($yn -like 'y*')) {
			clean
			write-host "registry overrides removed" -f darkgreen
		} else {
			write-host "
ok. if you change your mind later you can run `concfg clean` to remove the
overrides"
		}
	}

	$yn = read-host "would you like to open a new console to see the changes? (Y/n)"
	if(!$yn -or ($yn -like 'y*')) { start 'powershell.exe' -arg -nologo }
}

# handle the command
switch($cmd) {
	'import' { import_cmd @args }
	'export' {
		$json = export
		$path = $args[0]
		if($path) {
			$json | out-file $path -encoding utf8
			write-host "console settings exported to $(split-path $path -leaf)" -f darkgreen
		}
		else { $json }
	}
	'clean' {
		clean
		write-host "removed console property overrides from the registry" -f darkgreen
	}
	default { $usage }
}

exit 0