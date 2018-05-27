function command_files {
	Get-ChildItem ("$psscriptroot\..\libexec") | Where-Object { $_.name.endswith('.ps1') }
}

function commands {
	command_files | ForEach-Object { command_name $_ }
}

function command_name($filename) { $filename.name -replace '\.ps1$', '' }

function exec($cmd, $arguments) {
	& ("$psscriptroot\..\libexec\$cmd.ps1") @arguments
}
