# concfg

[![license][license-badge]](LICENSE) [![screenshots-svg]][screenshots-url] [![edit-online-svg]][edit-online-url]

`concfg` is a utility to import and export Windows console settings like fonts and colors.

> [!IMPORTANT]
>
> * Console settings can be overridden by program- or shortcut-specific
> settings stored in the registry or in the .lnk file itself. Concfg can
> attempt to clean these up for you by removing registry settings that
> might conflict and removing console properties from .lnk files in known
> directories. `concfg import` will prompt you to clean these up after
> an import, or you can run `concfg clean` at any time.
>
> * PowerShell's syntax highlighting isn't compatible with Base16's
> conventions by default. To set syntax highlighting to colors
> consistent with Base16's conventions, use `concfg tokencolor`
> sub-command to modify the syntax highlighting colors.

## Install

If you have [Scoop], you can install concfg with:

```
scoop install concfg
```

If you don't, you can download a zip of this repository,
and add `bin\concfg.ps1` to your PATH.

## Usage

### Using built-in presets

1. Use a color scheme, for example use the [Solarized] dark color presets:

```
concfg import solarized-dark
```

2. Add some opinioned settings (optional)

```
concfg import basic
```

This will import some opinioned non-color settings, such as fontFace and fontSize, etc.

```json
{
    "font_face": "Lucida Console",
    "font_true_type": true,
    "font_size": "0x14",
    "font_weight": 400,
    "cursor_size": "small",
    "window_size": "80x25",
    "screen_buffer_size": "80x1000",
    "command_history_length": 50,
    "num_history_buffers": 4,
    "quick_edit": false,
    "insert_mode": true,
    "fullscreen": false,
    "load_console_IME": true
}
```

You can also import multiple presets at once, the later sources will override settings from the earlier ones.

```
concfg import solarized-dark basic
```

3. If you want to revert to the default cmd color preset:

```
concfg import cmd-default
```

Or the default powershell color preset:

```
concfg import powershell-default
```

If you imported non-color settings such as fontFace, and you want to reset them:

```
concfg import basic-reset
```

**Note**: Since concfg will clean all program- or shortcut-specific settings
stored in the registry or in the .lnk file. So when you import a color preset,
all console applications (cmd.exe/powershell.exe) will use the same preset.
You can not set cmd.exe to use `cmd-default` while set powershell
to use `powershell-default`. That means when you import `powershell-default`,
your cmd.exe will also become powershell-blue. This is a known issue and proper behavior.

There are two default cmd color presets `cmd-default` and `cmd-legacy`,
please read [this article] to see the difference. And because of this, there are
also two default powershell presets `powershell-default` and `powershell-legacy`.

### Importing settings from a URL

```
concfg import https://raw.githubusercontent.com/lukesampson/concfg/master/presets/solarized-light.json
```

This URL happens to be one of the built in presets.
It's just an example of importing a URL.
The easy way to get Solarized light would be `concfg import solarized-light`

### Making your own settings to save or share

```
concfg export <path>
```

## Help

Type `concfg` without parameters to see the usage info.

## Credits

* Thanks to [Stephen Edgar] for adding support for [Chris Kempson]'s [base16] color
settings.
* Thanks to [Anant Anand Gupta] and MindzGroup Technologies for the online preview
and edit website.
* Concfg uses Ethan Schoonover's [Solarized] color theme.

## License

MIT

[license-badge]: https://img.shields.io/github/license/lukesampson/concfg?style=flat&logo=spdx
[screenshots-svg]: https://img.shields.io/badge/Preview-Screenshots-0067B8.svg?style=flat&logo=githubpages
[screenshots-url]: preset_examples/README.md
[edit-online-svg]: https://img.shields.io/badge/Edit-Online-0067B8.svg?style=flat&logo=githubpages
[edit-online-url]: https://chawyehsu.github.io/concfg/
[Scoop]: https://scoop.sh/
[Solarized]: https://ethanschoonover.com/solarized/
[this article]: https://blogs.msdn.microsoft.com/commandline/2017/08/02/updating-the-windows-console-colors/
[Stephen Edgar]: https://github.com/ntwb
[Chris Kempson]: https://github.com/chriskempson
[base16]: https://github.com/chriskempson/base16
[Anant Anand Gupta]: https://github.com/anantanandgupta
