# Usage: concfg clean
# Summary: Clean overrides from the registry and .lnk files
# Help: Cleans any program-specific overrides from the registry.

# Background: The Console will save program-specific overrides to the registry and sometimes
# shortcut files when you edit the console properties directly. These overrides can prevent
# your concfg settings from working properly.

. "$psscriptroot\..\lib\shortcut.ps1"
$pspath = "$pshome\powershell.exe"

function cleandir($dir) {
	if(!(test-path $dir)) { return }

	gci $dir | % {
		if($_.psiscontainer) { cleandir $_.fullname }
		else {
			$path = $_.fullname
			if(linksto $path $pspath) {
				if(!(rmprops $path)) {
					write-host "warning: admin permission is required to remove console props from $path" -f darkyellow
				}
			}
		}
	}
}

# clean registry
if(test-path hkcu:console) {
	gci hkcu:console | % {
		write-host "removing $($_.name)"
		rm "registry::$($_.name)"
	}
}

# clean .lnk files
$dirs = @(
	"~\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar",
	"~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell",
	"\ProgramData\Microsoft\Windows\Start Menu\Programs"
)

$dirs | % {	cleandir $_ }


