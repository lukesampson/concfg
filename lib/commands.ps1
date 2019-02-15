function command_files {
    Get-ChildItem ("$PSScriptRoot\..\libexec") | Where-Object {
        $_.Name.EndsWith('.ps1')
    }
}

function commands {
    command_files | ForEach-Object { command_name $_ }
}

function command_name($filename) {
    $filename.Name -replace '\.ps1$', ''
}

function exec($cmd, $arguments) {
    & ("$PSScriptRoot\..\libexec\$cmd.ps1") @arguments
}
