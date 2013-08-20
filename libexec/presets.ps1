# Usage: concfg presets
# Summary: List available presets
# Help: Lists the presets that are available for the 'concfg import' command

"Available presets:"
gci "$psscriptroot\..\presets" | % {
	"   $([io.path]::getfilenamewithoutextension($_.name))"
}