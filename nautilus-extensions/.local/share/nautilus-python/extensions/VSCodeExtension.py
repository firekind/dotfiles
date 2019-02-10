# VSCode Nautilus Extension
#
# Place me in ~/.local/share/nautilus-python/extensions/,
# ensure you have python-nautilus package, restrart Nautilus, and enjoy :)
#
# Quick install command:
# mkdir -p ~/.local/share/nautilus-python/extensions && cp -f VSCodeExtension.py ~/.local/share/nautilus-python/extensions/VSCodeExtension.py && nautilus -q
#
# Quick download + install command:
# wget https://gist.githubusercontent.com/cra0zy/f8ec780e16201f81ccd5234856546414/raw/6e53c15ea4b18de077587e781dc95dc7f0582cc3/VSCodeExtension.py && mkdir -p ~/.local/share/nautilus-python/extensions && cp -f VSCodeExtension.py ~/.local/share/nautilus-python/extensions/VSCodeExtension.py && rm VSCodeExtension.py && nautilus -q
#
# This script was written by cra0zy and is released to the public domain

from gi import require_version
require_version('Gtk', '3.0')
require_version('Nautilus', '3.0')
from gi.repository import Nautilus, GObject
from subprocess import call
import os

# path to vscode
VSCODE = 'code'

# what name do you want to see in the context menu?
VSCODENAME = 'Code'

# always create new window?
NEWWINDOW = False


class VSCodeExtension(GObject.GObject, Nautilus.MenuProvider):

    def launch_vscode(self, menu, files):
        safepaths = ''
        args = ''

        for file in files:
            filepath = file.get_location().get_path()
            safepaths += '"' + filepath + '" '

            # If one of the files we are trying to open is a folder
            # create a new instance of vscode
            if os.path.isdir(filepath) and os.path.exists(filepath):
                args = '--new-window '

        if NEWWINDOW:
            args = '--new-window '

        call(VSCODE + ' ' + args + safepaths + '&', shell=True)

    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name='VSCodeOpen',
            label='Open In ' + VSCODENAME,
            tip='Opens the selected files with VSCode'
        )
        item.connect('activate', self.launch_vscode, files)

        return [item]

    def get_background_items(self, window, file_):
        item = Nautilus.MenuItem(
            name='VSCodeOpenBackground',
            label='Open ' + VSCODENAME + ' Here',
            tip='Opens VSCode in the current directory'
        )
        item.connect('activate', self.launch_vscode, [file_])

        return [item]
