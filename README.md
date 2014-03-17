## concfg

`concfg` is a utility to import and export Windows console settings like fonts and colors.

If you have [Scoop](http://scoop.sh), you can install concfg with `scoop install concfg`.

### Important Caveats
* Console settings can be overridden by program- or shortcut-specific settings stored in the registry or in the .lnk file itself. Concfg can attempt to clean these up for you by removing registry settings that might conflict and removing console properties from .lnk files in known directories. `concfg import` will prompt you to clean these up after an import, or you can run `concfg clean` at any time. 

### Examples

##### Presets
Use the [Solarized](http://ethanschoonover.com/solarized) dark color presets:
```
concfg import solarized
```

Revert to the stock-standard console settings:
```
concfg import defaults
```

##### Importing settings from a URL

```
concfg import https://raw.github.com/lukesampson/concfg/master/presets/solarized-light.json

```
This URL happens to be one of the built in presets--it's just an example of importing a URL. The easy way to get Solarized light would be `concfg import solarized-light`

##### Making your own settings to save or share

```
concfg export <path>
```

Although, if you're making a color theme from scratch, you might find it easier to base it on presets/default.json

### Help

Type `concfg` without parameters to see the usage info.

### Credits
Thanks to Stephen Edgar([@ntwb](https://github.com/ntwb)) for adding support for [Chris Kempson](http://chriskempson.com/)'s [base16](http://chriskempson.github.io/base16/) color settings.

Concfg uses Ethan Schoonover's [Solarized](http://ethanschoonover.com/solarized) color theme.

Code for removing console properties from shortcuts is based on code from the [Coapp Toolkit](https://github.com/coapp/coapp) project.

