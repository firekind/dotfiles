from gi import require_version
require_version('Gtk', '3.0')
require_version('Nautilus', '3.0')
from gi.repository import Nautilus, GObject
from subprocess import call
import os

class OpenTerminatorExtension(GObject.GObject, Nautilus.MenuProvider):

    def launch_terminal(self, menu, files):
        safepaths = files.get_location().get_path()
        args = '--working-directory '

        print(safepaths)
        call('alacritty' + ' ' + args + safepaths + '&', shell=True)

    def get_file_items(self, window, files):
        if len(files) != 1:
            return

        f = files[0]
        item = Nautilus.MenuItem(
            name='TerminalOpen',
            label='Open Terminal Here',
            tip='Opens terminal in this directory'
        )
        item.connect('activate', self.launch_terminal, f)

        return [item]

    def get_background_items(self, window, file_):
        item = Nautilus.MenuItem(
            name='TerminalOpen',
            label='Open Terminal Here',
            tip='Opens terminal in this directory'
        )
        item.connect('activate', self.launch_terminal, file_)

        return [item]
