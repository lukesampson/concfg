. "$psscriptroot\..\lib\shortcut.ps1"
#Update-TypeData -AppendPath "$psscriptroot\comObject.types.ps1xml"

$p = '~\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\powershell.lnk'

linksto $p "$pshome\powershell.exe"
!(linksto "asdf" "$pshome\powershell.exe") # file not found
!(linksto "C:\windows\notepad.exe", "$pshome\powershell.exe") # not a shortcut

rmprops $p