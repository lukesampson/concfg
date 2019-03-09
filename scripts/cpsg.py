"""
    cpsg.py
    ~~~~~~
    Concfg Preset Screenshot Generator

    Only works in pure powershell/pwsh session, does not work in terminal like cmder.

    Prerequisites:
      Python3.4+, Pillow, jinja2, pywin32
"""
import os
import sys
import glob
import time
import shutil
import argparse
import win32gui
import subprocess
import win32process
from PIL import ImageGrab
from jinja2 import Template

LEGACY_PWSH = False
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
PRESETS_DIR = os.path.join(SCRIPT_DIR, os.pardir, 'presets')
PRESET_EXAMPLES_DIR = os.path.join(SCRIPT_DIR, os.pardir, 'preset_examples')
SKIP_LIST = ['basic', 'basic-reset']


def get_hwnds_for_pid(pid):
     def callback(hwnd, hwnds):
         if win32gui.IsWindowVisible(hwnd) and win32gui.IsWindowEnabled(hwnd):
             _, found_pid = win32process.GetWindowThreadProcessId(hwnd)
             if found_pid == pid:
                 hwnds.append(hwnd)
             return True
     hwnds = []
     win32gui.EnumWindows(callback, hwnds)
     return hwnds


def get_presets():
    files = glob.glob(os.path.join(PRESETS_DIR, '*.json'))
    presets = []

    for item in files:
        presets.append((os.path.splitext(os.path.basename(item))[0], item))

    # preset pair list [(name, path), (name, path), ...]
    return presets


def gens_for_preset(preset):
    exe = 'powershell' if LEGACY_PWSH else 'pwsh'

    print("Taking screenshot of preset '{0}'...".format(preset[0]))

    # set color preset
    pwsh = subprocess.Popen(
        '{0} -noprofile -file {1}/setcolors.ps1 -preset {2}'.format(exe, SCRIPT_DIR, preset[1]),
        creationflags=subprocess.CREATE_NEW_CONSOLE
    )
    # waiting for exit
    time.sleep(4.0)

    # print out color table then take screenshot
    pwsh = subprocess.Popen(
        '{0} -noprofile -noexit -file {1}/outcolors.ps1'.format(exe, SCRIPT_DIR),
        creationflags=subprocess.CREATE_NEW_CONSOLE
    )
    # waiting for process
    time.sleep(2.0)
    for hwnd in get_hwnds_for_pid(pwsh.pid):
        win32gui.SetForegroundWindow(hwnd)

    bbox = win32gui.GetWindowRect(hwnd)
    # remove window box shadow
    crop_bbox = (bbox[0]+7, bbox[1], bbox[2]-7, bbox[3]-7)
    img = ImageGrab.grab(crop_bbox)
    if not os.path.exists(PRESET_EXAMPLES_DIR):
        os.makedirs(PRESET_EXAMPLES_DIR)
    img.save(os.path.join(PRESET_EXAMPLES_DIR, '{0}.png'.format(preset[0])))
    pwsh.kill()


def img_dict(direntry):
    return {
        'name': direntry.name.replace('.png', ''),
        'path': direntry.name
    }


def is_img(direntry):
    if direntry.is_file and direntry.name.endswith('.png'):
        return True
    return False


if __name__ == '__main__':
    # Usage: python -m cpsg [args]
    parser = argparse.ArgumentParser(
        description='Concfg Preset Screenshot Generator')
    parser.add_argument("-a", "--all",
                        help="generate screenshot for all presets",
                        action="store_true")
    parser.add_argument("-l", "--legacy",
                        help="pass this option if you use Windows PowerShell",
                        action="store_true")
    parser.add_argument("-p", "--preset",
                        help="generate screenshot for single preset")
    parser.add_argument("-u", "--update",
                        help="also update the screenshot README",
                        action="store_true")
    args = parser.parse_args()

    if args.all or args.preset:

        if not shutil.which('colortool.exe'):
            print("Make sure you have 'ColorTool' installed.")
            sys.exit(0)

        input("NOTICE: Do not have other operations while the script runs, "
              "or it will be interrupted when taking screenshots. "
              "Hit Enter to continue: ")

        presets = get_presets()

        if args.legacy:
            LEGACY_PWSH = True

        if args.all:
            for item in presets:
                # skip non-color presets
                if not item[0] in SKIP_LIST:
                    gens_for_preset(item)
        elif args.preset:
            # skip non-color presets
            if not args.preset in SKIP_LIST:
                match = [item for item in presets if item[0] == args.preset]
                if len(match):
                    gens_for_preset(match[0])
                else:
                    print("No preset named '{0}'.".format(args.preset))
                    sys.exit(0)

        if args.update:
            print('Updating screenshots README.md...')
            # Get template
            with open(os.path.join(SCRIPT_DIR, 'readme.jinja2')) as templateData:
                template = Template(templateData.read())

            # Get images
            images = [img_dict(direntry) for direntry in os.scandir(PRESET_EXAMPLES_DIR) if is_img(direntry)]
            images.sort(key=lambda x: x['name'])

            # Generate README
            with open(os.path.join(PRESET_EXAMPLES_DIR, 'README.md'), 'w') as readme:
                readme.write(template.render(images=images))
    else:
        parser.print_help()
        sys.exit(0)
