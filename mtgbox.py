#!/usr/bin/env python3
import json
import os
import sys
import argparse
import subprocess

if os.name == 'nt':
    APP_PATH = 'd:\\softs\\openscad-2024.04\\openscad.exe'
    EXTRA = [ '--enable=manifold' ]
else:
    APP_PATH = '/home/marty/softs/openscad.appimage'
    EXTRA = ['--backend', 'manifold' ]

PROCESS = [
    lambda opts, name: [ '-D', 'OBJ="display"', '-o', opts.folder + '/' + 'render_' + name + '_disp.png',     '--camera', '7,17,17,62,0,37,495'  ],
    lambda opts, name: [ '-D', 'OBJ="all"',     '-o', opts.folder + '/' + 'render_' + name + '_all.png',      '--camera', '35,80,39,62,0,219,401' ],
    lambda opts, name: [ '-D', 'OBJ="inner"',   '-o', opts.folder + '/' + 'render_' + name + '_inner.png',    '--camera', '70,55,30,78,0,230,401' ],
    lambda opts, name: [ '-D', 'OBJ="outer"',   '-o', opts.folder + '/' + 'render_' + name + '_outer.png',    '--camera', '38,46,46,76,0,30,401'  ],
    lambda opts, name: [ '-D', 'OBJ="inner"',   '-o', opts.folder + '/' + 'box_' + name + '_inner.stl' ],
    lambda opts, name: [ '-D', 'OBJ="outer"',   '-o', opts.folder + '/' + 'box_' + name + '_outer.stl' ],
]

def do(opts):
    while opts.folder.endswith('/') or opts.folder.endswith('\\'):
        opts.folder = opts.folder[:-1]

    print(f'> target folder {opts.folder}')

    with open(os.path.join(opts.folder, 'info.json')) as f:
        info = json.load(f)
    # print(info)

    name = os.path.basename(opts.folder)
    print(f'name: {name}')

    for args in PROCESS:
        cmdline = [
            APP_PATH,
            '--colorscheme', 'DeepOcean',
            '--imgsize', '1024,1024',
            '-D', 'texture_enable=true',
        ] + EXTRA
        cmdline += args(opts, name)

        for k,v in info.items():
            cmdline.append('-D')

            if str(v) and os.path.exists(opts.folder + '/' + str(v)):
                v = opts.folder + '/' + v

            if isinstance(v, int):
                cmdline.append('%s=%d' % (k, v))
            elif isinstance(v, list):
                cmdline.append('%s=%r' % (k, v))
            else:
                cmdline.append('%s="%s"' % (k, str(v)))

        cmdline.append('v3.2.scad')

        print('calling: ', cmdline)
        subprocess.check_call(cmdline, executable=APP_PATH)

    print('> done')

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("folder", help="target folder")
    do(parser.parse_args())

if __name__ == '__main__':
    main()
