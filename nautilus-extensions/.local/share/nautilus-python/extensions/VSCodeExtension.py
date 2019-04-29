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
import subprocess
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
        print(files)
        for file in files:
            if type(file) == type(""):
                filepath=str(file)
            else:
                filepath = file.get_location().get_path()
            
            safepaths += '"' + filepath + '" '

            # If one of the files we are trying to open is a folder
            # create a new instance of vscode
            if os.path.isdir(filepath) and os.path.exists(filepath):
                args = '--new-window '

        if NEWWINDOW:
            args = '--new-window '

        subprocess.call(VSCODE + ' ' + args + safepaths + '&', shell=True)

    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name='VSCodeOpen',
            label='Open In ' + VSCODENAME,
            tip='Opens the selected files with VSCode'
        )
        item.connect('activate', self.launch_vscode, files)

        return [item]

    def get_background_items(self, window, file_):
        menuItems = []
        menuItems.append(Nautilus.MenuItem(
            name='VSCodeOpenBackground',
            label='Open ' + VSCODENAME + ' Here',
            tip='Opens VSCode in the current directory'
        ))
        menuItems[-1].connect('activate', self.launch_vscode, [file_])

        if file_ == None:
            return menuItems
        
        FNULL=open(os.devnull, 'w')
        loc = file_.get_location().get_path()
        isGitDir = subprocess.call("cd "+loc+"&& git rev-parse --is-inside-work-tree", shell=True, stdout=FNULL, stderr=FNULL)
        if isGitDir == 0:
            menuItems.append(Nautilus.MenuItem(
                name='VSCodeOpenProjectBackground',
                label='Open Project In ' + VSCODENAME,
                tip='Opens git project in VSCode'
            ))
            gitProjDir=subprocess.Popen(['git','rev-parse', '--show-toplevel'],
                    stdout=subprocess.PIPE,
                    stderr=FNULL,
                    cwd=loc).communicate()[0]
            menuItems[-1].connect('activate', self.launch_vscode, [gitProjDir.decode("utf-8").strip()])
	

        return menuItems


