function command_files {
    Get-ChildItem ("$PSScriptRoot\..\libexec") | Where-Object {
        $_.Name.EndsWith('.ps1')
    }
}

function commands {
    command_files | ForEach-Object { command_name $_ }
}

function command_name($filename) {
    return [System.IO.Path]::GetFileNameWithoutExtension($filename.Name)
}

function exec($cmd, $arguments) {
    & ("$PSScriptRoot\..\libexec\$cmd.ps1") @arguments
}
