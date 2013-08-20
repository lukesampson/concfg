function linksto($path, $target) {
	if(!(test-path $path)) { return $false }
	if($path -notmatch '\.lnk$') { return $false }

	$path = "$(resolve-path $path)"

	$shell = new-object -com wscript.shell -strict
	$shortcut = $shell.createshortcut($path)

	$result = $shortcut.targetpath -eq $target
	[Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) > $null
	return $result
}
