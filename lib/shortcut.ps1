function linksto($path, $target) {
	if(!(test-path $path)) { return $false }
	if($path -notmatch '\.lnk$') { return $false }

	$path = "$(resolve-path $path)"

	$shell = new-object -com wscript.shell -strict
	$shortcut = $shell.createshortcut($path)

	return $shortcut.targetpath -eq $target
}
