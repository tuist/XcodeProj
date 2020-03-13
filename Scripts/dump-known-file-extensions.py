#!/usr/bin/env python

import json
import os
import plistlib
import re
import subprocess
import sys


def parse_xcspec(path):
    # convert ASCII plist to XML format and read as string
    xml_string = subprocess.check_output([
        'plutil', '-convert', 'xml1', '-o', '-', '--', path])
    return plistlib.readPlistFromString(xml_string)


def extract_extensions(path, into={}):
    data = parse_xcspec(path)
    extracted = 0

    if isinstance(data, list):
        for item in data:
            if 'Identifier' in item and 'Extensions' in item:
                ident = item['Identifier']
                for ext in item['Extensions']:
                    into[ext] = ident
                    extracted += 1

    if extracted > 0:
        sys.stderr.write('** Extracted {} extensions from {}\n'.format(
            extracted, path))

    return into


def run(xcode_path):
    plugins_path = os.path.join(xcode_path, 'Contents', 'PlugIns')
    matcher = re.compile(r'\.(xcspec|pbfilespec)$')
    all_extensions = {}
    for root, dirs, files in os.walk(plugins_path):
        for file in files:
            if matcher.search(file):
                path = os.path.join(root, file)
                extract_extensions(path, all_extensions)

    json.dump(
        all_extensions,
        sys.stdout,
        sort_keys=True,
        indent=4,
        separators=(',', ': ')
    )


if __name__ == '__main__':
    if len(sys.argv) == 2:
        run(sys.argv[1])
    else:
        sys.stderr.write('usage: {} /path/to/Xcode.app\n'.format(
            os.path.basename(sys.argv[0])))
        exit(1)
