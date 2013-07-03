#requires -v 3
param($cmd)

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\commands"

$commands = commands

if (@($null, '-h', '--help') -contains $cmd) { exec 'help' $args }
elseif ($commands -contains $cmd) { exec $cmd $args }
else { "concfg: '$cmd' isn't a concfg command. See 'concfg help'"; exit 1 }

exit 0