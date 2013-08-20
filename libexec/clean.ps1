# Usage: concfg clean
# Summary: Clean overrides from the registry
# Help: Cleans any program-specific overrides from the registry.

# Background: The Console will save program-specific overrides to the registry when you
# edit the console properties directly. These overrides can prevent your concfg settings
# from working properly.

if(test-path hkcu:console) {
    gci hkcu:console | % { rm "registry::$($_.name)" }
}