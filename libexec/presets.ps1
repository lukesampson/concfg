# Usage: concfg presets
# Summary: List available presets
# Help: Lists the presets that are available for the 'concfg import' command

"Available presets:"
Get-ChildItem "$psscriptroot\..\presets" | ForEach-Object {
	"   $([io.path]::getfilenamewithoutextension($_.name))"
}
