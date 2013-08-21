function linksto($path, $target) {
	if(!(isshortcut $path)) { return $false }

	$path = "$(resolve-path $path)"

	$shell = new-object -com wscript.shell -strict
	$shortcut = $shell.createshortcut($path)

	$result = $shortcut.targetpath -eq $target
	[Runtime.Interopservices.Marshal]::ReleaseComObject($shortcut) > $null
	return $result
}

function isshortcut($path) {
	if(!(test-path $path)) { return $false }
	if($path -notmatch '\.lnk$') { return $false }
	return $true
}

# based on code from coapp:
# https://github.com/coapp/coapp/tree/master/toolkit/Shell
$cs = @"
using System;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;

namespace concfg {

	public static class Shortcut {
		public static void RmProps(string path) {
			var NT_CONSOLE_PROPS_SIG = 0xA0000002;
			var STGM_READ = 0;

			var lnk = new ShellLinkCoClass();
			var data = (IShellLinkDataList)lnk;
			var file = (IPersistFile)lnk;

			file.Load(path, STGM_READ);
			data.RemoveDataBlock(NT_CONSOLE_PROPS_SIG);
			file.Save(path, true);

			Marshal.ReleaseComObject(data);
			Marshal.ReleaseComObject(file);
			Marshal.ReleaseComObject(lnk);
		}
	}

	[ComImport, Guid("00021401-0000-0000-C000-000000000046")]
	class ShellLinkCoClass { }

	[ComImport,
	InterfaceType(ComInterfaceType.InterfaceIsIUnknown),
	Guid("45e2b4ae-b1c3-11d0-b92f-00a0c90312e1")]
	interface IShellLinkDataList {
		void _VtblGap1_2(); // AddDataBlock, CopyDataBlock
		[PreserveSig]
		Int32 RemoveDataBlock(UInt32 dwSig);
		void _VtblGap2_2(); // GetFlag, SetFlag
	}
}
"@

add-type -typedef $cs -lang csharp

function rmprops($path) {
	if(!(isshortcut $path)) { return $false }

	$path = "$(resolve-path $path)"
	try { [concfg.shortcut]::rmprops($path) }
	catch [UnauthorizedAccessException] {
		return $false
	}
	$true
}