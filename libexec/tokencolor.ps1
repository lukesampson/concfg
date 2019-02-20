# Usage: concfg tokencolor [options] <enable>|<disable>
# Summary: Correct PSReadline command line token color mappings
# Help: e.g. concfg tokencolor enable
#
# Background: This script is used to set syntax highlighting colors
# of the PSReadline module, and affect the colors of command line
# (only command line tokens, not prompt). It"s an enhancement,
# not decisive factor to theming. The color of tokens is determined by
# what theme you use. If you use solorized_dark, this script will automatically
# use solorized_dark mapping colours to improve the colors of command line,
# make them easier to be recognized and looks better.
#
# Since we use base16 for building themes, we follow base16's styling
# guidelines(https://github.com/chriskempson/base16/blob/master/styling.md)
# to configure token colours, for example:
#   Keyword -> base0E
#   String  -> base0B
#
# You have to install PSReadline module before you do it.
# If you are on Windows 10, PSReadLine is already installed. More information:
#   https://github.com/lzybkr/PSReadLine#installation
# Options:
#   --non-interactive, -n: don't prompt Output
. "$PSScriptRoot\..\lib\help.ps1"
. "$PSScriptRoot\..\lib\getopt.ps1"

function enable($non_interactive) {
    # Enable for current process
    settokencolor $non_interactive

    # Find $Profile
    if(!(test-path $profile)) {
        $profile_dir = split-path $profile
        if(!(test-path $profile_dir)) { mkdir $profile_dir > $null }
        '' > $profile
    }
    $text = Get-Content $profile

    if (!$non_interactive) {
        if($null -eq ($text | Select-String 'concfg tokencolor')) {
            Write-Output 'Adding concfg tokencolor to your powershell profile...'

            # read and write whole profile to avoid problems with line endings and encodings
            $new_profile = @($text) + "try { `$null = Get-Command concfg -ea stop; concfg tokencolor -n enable } catch { }"
            $new_profile > $profile
        } else {
            if ($null -eq ($text | Select-String 'concfg tokencolor -n disable')) {
                Write-Output 'It looks like you have enabled tokencolor in your powershell profile, skipped'
            } else {
                $new_profile = $text.Replace("concfg tokencolor -n disable", "concfg tokencolor -n enable")
                $new_profile > $profile
            }
        }
    }
}

function disable($non_interactive) {
    # Find $Profile
    if(!(test-path $profile)) {
        $profile_dir = split-path $profile
        if(!(test-path $profile_dir)) { mkdir $profile_dir > $null }
        '' > $profile
    }

    $text = Get-Content $profile
    if($null -eq ($text | Select-String 'concfg tokencolor')) {
        # DO NOTHING
    } else {
        $new_profile = $text.Replace("concfg tokencolor -n enable", "concfg tokencolor -n disable")
        $new_profile > $profile
    }

    # Disable for current process
    resettokencolor $non_interactive
}

function settokencolor($non_interactive) {
    if (!(Get-Module -ListAvailable -Name "PSReadline")) {
        if(!$non_interactive) {
            Write-Output "ERROR: you have to install PSReadline to use token colors"
        }
        exit 1
    } else {
        # PSReadLine 1
        if ((Get-Module -ListAvailable -Name "PSReadline").Version.Major -eq 1) {
            # Reset
            Set-PSReadlineOption -ResetTokenColors

            $options = Get-PSReadlineOption
            # Token Foreground                                # base16 colors
            $options.CommandForegroundColor   = "DarkBlue"    # base0D
            $options.CommentForegroundColor   = "Yellow"      # base03
            $options.KeywordForegroundColor   = "DarkMagenta" # base0E
            $options.MemberForegroundColor    = "DarkBlue"    # base0D
            $options.NumberForegroundColor    = "Red"         # base09
            $options.OperatorForegroundColor  = "DarkCyan"    # base0C
            $options.ParameterForegroundColor = "Red"         # base09
            $options.StringForegroundColor    = "DarkGreen"   # base0B
            $options.TypeForegroundColor      = "DarkYellow"  # base0A
            $options.VariableForegroundColor  = "DarkRed"     # base08
        } else {
            # Token Foreground                                # base16 colors
            Set-PSReadLineOption -Colors @{
                "Command"   = [ConsoleColor]::DarkBlue        # base0D
                "Comment"   = [ConsoleColor]::Yellow          # base03
                "Keyword"   = [ConsoleColor]::DarkMagenta     # base0E
                "Member"    = [ConsoleColor]::DarkBlue        # base0D
                "Number"    = [ConsoleColor]::Red             # base09
                "Operator"  = [ConsoleColor]::DarkCyan        # base0C
                "Parameter" = [ConsoleColor]::Red             # base09
                "String"    = [ConsoleColor]::DarkGreen       # base0B
                "Type"      = [ConsoleColor]::DarkYellow      # base0A
                "Variable"  = [ConsoleColor]::DarkRed         # base08
            }
        }

        if (!$non_interactive) {
            Write-Output "concfg tokencolor enabled."
        }
    }
}

function resettokencolor($non_interactive) {
    if (!(Get-Module -ListAvailable -Name "PSReadline")) {
        if(!$non_interactive) {
            Write-Output "ERROR: you have to install PSReadline to use token colors"
        }
        exit 1
    } else {
        # PSReadLine 1
        if ((Get-Module -ListAvailable -Name "PSReadline").Version.Major -eq 1) {
            # Reset
            Set-PSReadlineOption -ResetTokenColors
        } else {
            # Default Colors
            Set-PSReadLineOption -Colors @{
                "Command"   = [ConsoleColor]::Yellow
                "Comment"   = [ConsoleColor]::DarkGreen
                "Keyword"   = [ConsoleColor]::Green
                "Member"    = [ConsoleColor]::White
                "Number"    = [ConsoleColor]::White
                "Operator"  = [ConsoleColor]::DarkGray
                "Parameter" = [ConsoleColor]::DarkGray
                "String"    = [ConsoleColor]::DarkCyan
                "Type"      = [ConsoleColor]::Gray
                "Variable"  = [ConsoleColor]::Green
            }
        }

        if (!$non_interactive) {
            Write-Output "concfg tokencolor disabled."
        }
    }
}

$opts, $args, $err = getopt $args 'n' @('non-interactive')

if ($err) {
    "concfg: ERROR: $err"
    my_usage
    exit 1
}

$non_interactive = $opts['non-interactive'] -or $opts.n

if ($args.length -eq 0) {
    my_usage
    exit 1
} else {
    if ($args -eq "enable") {
        enable $non_interactive
    } elseif ($args -eq "disable") {
        disable $non_interactive
    } else {
        my_usage
        exit 1
    }
}
