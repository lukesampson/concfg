param (
    [string]$preset = ""
)

concfg clean
concfg import -n $preset
