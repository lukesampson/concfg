import os

from jinja2 import Template

current_dir = os.path.realpath('.')

def img_dict(direntry):
    return {
        "name": direntry.name.replace(".png", ''),
        "path": direntry.name
    }

def is_img(direntry):
    if direntry.is_file and direntry.name.endswith('.png'):
        return True
    return False

# Get template
with open(os.path.join(current_dir, 'readme.jinja2')) as templateData:
    template = Template(templateData.read())

# Get images
images = [img_dict(direntry) for direntry in os.scandir(current_dir) if is_img(direntry)]
images.sort(key=lambda x: x['name'])

# Generate README
with open('README.md', 'w') as readme:
    readme.write(template.render(images=images))

