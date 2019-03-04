Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;

namespace Concfg {
    public class ShortcutManager {
        public static void ResetConsoleProperties(string path) {
            if (!System.IO.File.Exists(path)) { return; }

            var lnk = new ShellLink();
            var data = (IShellLinkDataList)lnk;
			var file = (IPersistFile)lnk;

            file.Load(path, 2 /* STGM_READWRITE */);
            data.RemoveDataBlock( 0xA0000002 /* NT_CONSOLE_PROPS_SIG */);
            file.Save(path, true);

            Marshal.ReleaseComObject(data);
            Marshal.ReleaseComObject(file);
            Marshal.ReleaseComObject(lnk);
        }
    }
    [ComImport, Guid("00021401-0000-0000-C000-000000000046")]
    class ShellLink { }
    [ComImport, Guid("45e2b4ae-b1c3-11d0-b92f-00a0c90312e1"),
    InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IShellLinkDataList {
        void AddDataBlock(IntPtr pDataBlock);
        void CopyDataBlock(uint dwSig, out IntPtr ppDataBlock);
        void RemoveDataBlock(uint dwSig);
        void GetFlags(out uint pdwFlags);
        void SetFlags(uint dwFlags);
    }
}
'@

function Test-IsPowershellShortcut($path) {
    if (!(Test-IsShortcut $path)) { return $false }

    $shell = New-Object -COMObject WScript.Shell -Strict
    $shortcut = $shell.CreateShortcut("$(Resolve-Path $path)")

    # Test if the shortcut's target is powershell.exe or pwsh.exe
    $result = ($shortcut.TargetPath -eq "$PSHOME\powershell.exe") -or `
        ($shortcut.TargetPath -eq "$PSHOME\pwsh.exe") -or `
        ($shortcut.TargetPath -eq "$env:WINDIR\system32\WindowsPowerShell\v1.0\powershell.exe") -or `
        ($shortcut.TargetPath -eq "$env:WINDIR\syswow64\WindowsPowerShell\v1.0\powershell.exe")
    [Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) | Out-Null

    return $result
}

function Test-IsShortcut($path) {
    # $path does not exist.
    if (!(Test-Path -LiteralPath $path)) { return $false }
    # $path is not a valid shortcut (.lnk) file.
    if ([System.IO.Path]::GetExtension($path) -ne ".lnk") { return $false }
    return $true
}

function Remove-Property($path) {
    if (!(Test-IsShortcut $path)) { return $false }

    $path = "$(Resolve-Path $path)"
    try {
        [Concfg.ShortcutManager]::ResetConsoleProperties($path)
        Write-Output "Reset console properties of shortcut '$path'"
    } catch [UnauthorizedAccessException] {
        Write-Warning "admin permission is required to remove console props from '$path'"
    }
}

function Reset-PowerShellShortcut($dir) {
    if (!(Test-Path $dir)) { return }

    Get-ChildItem $dir | ForEach-Object {
        if ($_.PsIsContainer) {
            Reset-PowerShellShortcut $_.FullName
        } else {
            $path = $_.FullName
            if (Test-IsPowershellShortcut $path) {
                Remove-Property $path
            }
        }
    }
}
