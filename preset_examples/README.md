# Automated Screenshots of included Presets


## 3024

![3024](./3024.png "3024")

## 3024.light

![3024.light](./3024.light.png "3024.light")

## atelierdune

![atelierdune](./atelierdune.png "atelierdune")

## atelierdune.light

![atelierdune.light](./atelierdune.light.png "atelierdune.light")

## atelierforest

![atelierforest](./atelierforest.png "atelierforest")

## atelierforest.light

![atelierforest.light](./atelierforest.light.png "atelierforest.light")

## atelierheath

![atelierheath](./atelierheath.png "atelierheath")

## atelierheath.light

![atelierheath.light](./atelierheath.light.png "atelierheath.light")

## atelierlakeside

![atelierlakeside](./atelierlakeside.png "atelierlakeside")

## atelierlikeside.light

![atelierlikeside.light](./atelierlikeside.light.png "atelierlikeside.light")

## atelierseaside

![atelierseaside](./atelierseaside.png "atelierseaside")

## atelierseaside.light

![atelierseaside.light](./atelierseaside.light.png "atelierseaside.light")

## bespin

![bespin](./bespin.png "bespin")

## bespin.light

![bespin.light](./bespin.light.png "bespin.light")

## big

![big](./big.png "big")

## chalk

![chalk](./chalk.png "chalk")

## chalk.light

![chalk.light](./chalk.light.png "chalk.light")

## defaults

![defaults](./defaults.png "defaults")

## eighties

![eighties](./eighties.png "eighties")

## eighties.light

![eighties.light](./eighties.light.png "eighties.light")

## flat

![flat](./flat.png "flat")

## grayscale

![grayscale](./grayscale.png "grayscale")

## grayscale.light

![grayscale.light](./grayscale.light.png "grayscale.light")

## greenscreen

![greenscreen](./greenscreen.png "greenscreen")

## greenscreen.light

![greenscreen.light](./greenscreen.light.png "greenscreen.light")

## isotope

![isotope](./isotope.png "isotope")

## isotope.light

![isotope.light](./isotope.light.png "isotope.light")

## londontube

![londontube](./londontube.png "londontube")

## londontube.light

![londontube.light](./londontube.light.png "londontube.light")

## marrakesh

![marrakesh](./marrakesh.png "marrakesh")

## marrakesh.light

![marrakesh.light](./marrakesh.light.png "marrakesh.light")

## medium

![medium](./medium.png "medium")

## mocha

![mocha](./mocha.png "mocha")

## mocha.light

![mocha.light](./mocha.light.png "mocha.light")

## monokai

![monokai](./monokai.png "monokai")

## monokai.light

![monokai.light](./monokai.light.png "monokai.light")

## mountain

![mountain](./mountain.png "mountain")

## ocean

![ocean](./ocean.png "ocean")

## ocean.light

![ocean.light](./ocean.light.png "ocean.light")

## oceanicnext

![oceanicnext](./oceanicnext.png "oceanicnext")

## paraiso

![paraiso](./paraiso.png "paraiso")

## paraiso.light

![paraiso.light](./paraiso.light.png "paraiso.light")

## powershell-defaults

![powershell-defaults](./powershell-defaults.png "powershell-defaults")

## railscasts

![railscasts](./railscasts.png "railscasts")

## railscasts.light

![railscasts.light](./railscasts.light.png "railscasts.light")

## shapshifter

![shapshifter](./shapshifter.png "shapshifter")

## shapshifter.light

![shapshifter.light](./shapshifter.light.png "shapshifter.light")

## small

![small](./small.png "small")

## solarized

![solarized](./solarized.png "solarized")

## solarized-light

![solarized-light](./solarized-light.png "solarized-light")

## tomorrow

![tomorrow](./tomorrow.png "tomorrow")

## tomorrow.light

![tomorrow.light](./tomorrow.light.png "tomorrow.light")

## twilight

![twilight](./twilight.png "twilight")

## twilight.light

![twilight.light](./twilight.light.png "twilight.light")


# Generate Windows to perform Screenshots

1. Open powershell and navigate to the directory that contains `outcolors.ps1` and `theme-output-comparison.ps1`.
2. execute `theme-output-comparison.ps1` 
3. Wait for all presets to finish.
4. Take screenshots of each screen cropping out prompt.

# Generating README

## requirements

1. python 3.5
2. jinja2

## generation

1. open terminal to folder containing all images.
2. run `python gen_readme.py`