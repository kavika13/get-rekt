#!/usr/bin/env python

import argparse
from enum import Enum

from PIL import Image


class MapCell(Enum):
    walkable = 0
    unwalkable = 1
    door = 2


PIXEL_TO_WALKABILITY_MAP = {
    (255, 255, 255): MapCell.walkable,
    (0, 0, 0): MapCell.unwalkable,
    (255, 0, 0): MapCell.door,
}


def convert_images_to_coffeescript(image_filenames):
    for filename in image_filenames:
        current_image = Image.open(filename)
        print(', '.join(
            str(PIXEL_TO_WALKABILITY_MAP[pixel])
            for pixel in current_image.getdata()))


def convert_images_to_javascript(image_filenames):
    pass


parser = argparse.ArgumentParser(
    description='Convert a walkability map image to a walkabaility matrix.')

parser.add_argument(
    'image_filenames', metavar='IMAGE_FILENAME', help='a file to process',
    nargs='+')

output_choices = parser.add_mutually_exclusive_group(required=True)
output_choices.add_argument(
    '--javascript', help='output as javascript', dest='process',
    action='store_const', const=convert_images_to_javascript)
output_choices.add_argument(
    '--coffeescript', help='output as coffeescript', dest='process',
    action='store_const', const=convert_images_to_coffeescript)

args = parser.parse_args()
args.process(args.image_filenames)
