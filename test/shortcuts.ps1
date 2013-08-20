. "$psscriptroot\..\lib\shortcut.ps1"
#Update-TypeData -AppendPath "$psscriptroot\comObject.types.ps1xml"

$p = '~\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\powershell.lnk'

linksto $p "$pshome\powershell.exe"
!(linksto "asdf" "$pshome\powershell.exe") # file not found
!(linksto "C:\windows\notepad.exe", "$pshome\powershell.exe") # not a shortcut


$x = new-object -com lnkfile
$clsid_ipersistfile = [guid]::parse("0000010B-0000-0000-C000-000000000046")

$p = "$(resolve-path $p)"
$y = $null
[__comobject].invokemember("Load", [reflection.bindingflags]::invokemethod, $null, $x, ($p, 0))
#$x.invokemethod("Load", $p, 0)