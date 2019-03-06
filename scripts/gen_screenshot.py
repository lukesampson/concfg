import os
import glob
import win32gui
import win32process

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
PRESETS_DIR = os.path.join(SCRIPT_DIR, os.pardir, 'presets')
PRESET_EXAMPLES_DIR = os.path.join(SCRIPT_DIR, os.pardir, 'preset_examples')

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
    return glob.glob(os.path.join(PRESETS_DIR, '*.json'))


if __name__ == '__main__':
    import subprocess
    import time
    from PIL import ImageGrab

    presets = get_presets()

    for item in presets:
        preset_name = os.path.splitext(os.path.basename(item))[0]

        # skip non-color preset basic.json
        if not preset_name == 'basic':
            # set color preset
            pwsh = subprocess.Popen(
                'pwsh -noprofile -file ./setcolors.ps1 -preset {0}'.format(item),
                creationflags=subprocess.CREATE_NEW_CONSOLE
            )
            # waiting for exit
            time.sleep(5.0)

            # print out color table then take screenshot
            pwsh = subprocess.Popen(
                'pwsh -noprofile -noexit -file ./outcolors.ps1',
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
            img.save(os.path.join(PRESET_EXAMPLES_DIR, '{0}.png'.format(preset_name)))
            pwsh.kill()
