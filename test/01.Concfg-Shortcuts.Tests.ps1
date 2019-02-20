. "$PSScriptRoot\..\lib\shortcut.ps1"

$real_path = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
$fake_not_exist = "asdf"
$fale_not_shortcut = "C:\windows\notepad.exe"

Describe "Project Code" {
    Context "Checking Shortcut Utilities" {
        It "First path should be a Powershell shortcut" {
            (Test-IsPowershellShortcut $real_path) | Should Be $true
        }
        It "Second path should not be a Powershell shortcut" {
            !(Test-IsPowershellShortcut $fake_not_exist) | Should Be $true
        }
        It "Third path should not be a Powershell shortcut" {
            !(Test-IsPowershellShortcut $fale_not_shortcut) | Should Be $true
        }
        It "Remove console properties from first path should work" {
            (Remove-Property $real_path) | Should Be $true
        }
        It "Remove console properties from second path should not work" {
            !(Remove-Property $fake_not_exist) | Should Be $true
        }
        It "Remove console properties from third path should not work" {
            !(Remove-Property $fale_not_shortcut) | Should Be $true
        }
    }
}
