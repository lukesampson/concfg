. "$psscriptroot\..\lib\shortcut.ps1"

$p = '~\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\powershell.lnk'

linksto $p "$pshome\powershell.exe"
!(linksto "asdf" "$pshome\powershell.exe") # file not found
!(linksto "C:\windows\notepad.exe", "$pshome\powershell.exe") # not a shortcut