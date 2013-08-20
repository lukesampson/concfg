function command_files {
	gci ("$psscriptroot\..\libexec") | where { $_.name.endswith('.ps1') }
}

function commands {
	command_files | % { command_name $_ }
}

function command_name($filename) { $filename.name -replace '\.ps1$', '' }

function exec($cmd, $arguments) {
	& ("$psscriptroot\..\libexec\$cmd.ps1") @arguments
}