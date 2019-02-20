# concfg

`concfg` is a utility to import and export Windows console settings like fonts and colors.

If you have [Scoop](https://scoop.sh), you can install concfg with `scoop install concfg`.

### [You Can Preview and Edit Themes Here!](http://github.mindzgroup.com/concfg)
...thanks to [Anant Anand Gupta](https://about.me/anantanandgupta) and [MindzGroup Technologies](http://github.mindzgroup.com).

### Important Caveats
* Console settings can be overridden by program- or shortcut-specific settings stored in the registry or in the .lnk file itself. Concfg can attempt to clean these up for you by removing registry settings that might conflict and removing console properties from .lnk files in known directories. `concfg import` will prompt you to clean these up after an import, or you can run `concfg clean` at any time.
* PowerShell's syntax highlighting isn't compatible with Base16's conventions by default. To set syntax highlighting to colors consistent with Base16's conventions,
use `concfg tokencolor` sub-command to modify the syntax highlighting colors.

[Screenshots of included presets](./preset_examples/README.md)

## Usage

### Use built-in presets

1. Use a color scheme, for example use the [Solarized](http://ethanschoonover.com/solarized) dark color presets:

```
concfg import solarized-dark
```

2. Add some opinioned settings (optional)

```
concfg import basic
```

This will import some opinioned non-color settings, such as fontFace and fontSize, etc.

You can also import multiple presets once, the later sources will override settings from the earlier ones.

```
concfg import solarized-dark basic
```

3. If you want to revert to the stock-standard console color preset:

```
concfg import windows-console-defaults
```

**Note**: Since concfg will clean all program- or shortcut-specific settings
stored in the registry or in the .lnk file. So when you import a color preset,
all console applications (cmd.exe/powershell.exe) will use the same preset.
You can not set cmd.exe to use windows-console-defaults while set powershell
to use powershell-defaults.

### Importing settings from a URL

```
concfg import https://raw.githubusercontent.com/lukesampson/concfg/master/presets/solarized-light.json
```

This URL happens to be one of the built in presets. It's just an example of importing a URL.
The easy way to get Solarized light would be `concfg import solarized-light`

### Making your own settings to save or share

```
concfg export <path>
```

## Help

Type `concfg` without parameters to see the usage info.

## Credits
Thanks to Stephen Edgar([@ntwb](https://github.com/ntwb)) for adding support for
[Chris Kempson](http://chriskempson.com/)'s [base16](http://chriskempson.github.io/base16/) color settings.

Concfg uses Ethan Schoonover's [Solarized](http://ethanschoonover.com/solarized) color theme.

## License

MIT
