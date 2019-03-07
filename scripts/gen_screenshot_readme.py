import os
from jinja2 import Template

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
PRESET_EXAMPLES_DIR = os.path.join(SCRIPT_DIR, os.pardir, 'preset_examples')


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
    # Get template
    with open(os.path.join(SCRIPT_DIR, 'screenshot_readme.jinja2')) as templateData:
        template = Template(templateData.read())

    # Get images
    images = [img_dict(direntry) for direntry in os.scandir(PRESET_EXAMPLES_DIR) if is_img(direntry)]
    images.sort(key=lambda x: x['name'])

    # Generate README
    with open(os.path.join(PRESET_EXAMPLES_DIR, 'README.md'), 'w') as readme:
        readme.write(template.render(images=images))
