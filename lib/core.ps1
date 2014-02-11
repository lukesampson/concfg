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

function wraptext($text, $width) {
	if(!$width) { $width = $host.ui.rawui.windowsize.width };
	$width -= 1 # be conservative: doesn't seem to print the last char

	$text -split '\r?\n' | % {
		$line = ''
		$_ -split ' ' | % {
			if($line.length -eq 0) { $line = $_ }
			elseif($line.length + $_.length + 1 -le $width) { $line += " $_" }
			else { $lines += ,$line; $line = $_ }
		}
		$lines += ,$line
	}

	$lines -join "`n"
}