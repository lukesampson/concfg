#Requires -Version 3
Param($cmd)

. "$PSScriptRoot\..\lib\core.ps1"
. "$PSScriptRoot\..\lib\commands.ps1"

$commands = commands

if (@($null, '-h', '--help') -contains $cmd) {
    exec 'help' $args
} elseif ($commands -contains $cmd) {
    exec $cmd $args
} else {
    "concfg: '$cmd' isn't a concfg command. See 'concfg help'"
    exit 1
}

exit 0
