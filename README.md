## concfg

`concfg` is a utility to import and export Windows console settings like fonts and colors. It includes presets for Ethan Schoonover's excellent [Solarized](http://ethanschoonover.com/solarized) color theme.

If you have [Scoop](http://scoop.sh), you can install concfg with `scoop install concfg`.

### Important Caveats
* Console will need to be restarted after an import before you see the changes.

* Console settings can be overridden by program- or shortcut-specific settings stored in the registry or in the .lnk file itself. If you're importing settings, you can run `concfg clean` to remove registry settings that might conflict. If you're still not seeing changes (likely if you're using a PowerShell shortcut to launch the console), then you might want to use Windows-key, 'powershell.exe' to launch it directly, or create your own fresh shortcut (don't copy an existing PowerShell one!).

### Examples

##### Presets
Use the [Solarized](http://ethanschoonover.com/solarized) dark color presets:
```
concfg import solarized
```

Revert to the stock-standard console settings:
```
concfg import default
```

##### Importing settings from a URL

```
concfg import http://github.com/lukesampson/presets/solarized-light.json

```
This URL happens to be one of the built in presets--it's just an example of importing a URL. The easy way to get Solarized light would be `concfg import solarized-light`

##### Making your own settings to save or share

```
concfg export <path>
```

Although, if you're making a color theme from scratch, you might find it easier to base it on presets/default.json

### Help

Type `concfg` without parameters to see the usage info.
