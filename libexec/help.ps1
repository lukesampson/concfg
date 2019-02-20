# Usage: concfg help <command>
# Summary: Show help for a command
Param($cmd)

. "$PSScriptRoot\..\lib\core.ps1"
. "$PSScriptRoot\..\lib\commands.ps1"
. "$PSScriptRoot\..\lib\help.ps1"

function print_help($cmd) {
    $file = Get-Content ("$PSScriptRoot\$cmd.ps1") -Raw

    $usage = usage $file
    $summary = summary $file
    $help = help $file

    if ($usage) { "$usage" }
    if ($help) { "`n$help" }
}

function print_summaries {
    $summaries = @{}

    command_files | ForEach-Object {
        $command = command_name $_
        $summary = summary (Get-Content $_.FullName -Raw )
        if (!($summary)) { $summary = '' }
        $summaries.Add("$command ", $summary) # add padding
    }

    ($summaries.GetEnumerator() | Sort-Object name | Format-Table -HideTableHeaders -AutoSize -Wrap | Out-String).TrimEnd()
}

$commands = commands

if (!($cmd)) {
    "Usage: concfg <command> [<args]

Some useful commands are:"
    print_summaries
    "`nType 'concfg help <command>' to get help for a specific command."
} elseif ($commands -contains $cmd) {
    print_help $cmd
} else {
    "concfg help: no such command '$cmd'"; exit 1
}

exit 0
