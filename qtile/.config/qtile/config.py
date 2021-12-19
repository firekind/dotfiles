import os
from posixpath import expanduser
import re
import subprocess
from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.log_utils import logger

import utils


class Config:
    num_screens = utils.get_num_screens()
    group_names = ["term", "code", "web", "dev", "app", "misc", "gfx", "chat"]
    window_groups = {
        "code": [{"wm_class": "Code"}],
        "web": [
            {"wm_class": "Firefox"},
            {"wm_class": "firefox"},
            {"wm_class": "Chromium"},
        ],
        "app": [
            {"wm_class": "Org.gnome.Nautilus"},
            {"wm_class": "obs"},
        ],
        "misc": [
            {"wm_class": "vlc"},
        ],
        "gfx": [
            {"wm_class": re.compile("(?im)Gimp-*")},
        ],
        "chat": [
            {"wm_class": "Signal"},
            {"wm_class": "TelegramDesktop"},
        ],
    }
    float_windows = [
        {"wm_class": "GParted"},
        {"wm_class": "Lxappearance"},
        {"wm_class": "Nitrogen"},
        {"wm_class": "Nm-connection-editor"},
        {"wm_class": "Pavucontrol"},
        {"wm_class": "Zenity", "title": "=Authentication"},
        {"wm_class": "File-roller"},
        {"wm_class": "confirmreset"},  # gitk
        {"wm_class": "makebranch"},  # gtik
        {"wm_class": "maketag"},  # gtik
        {"wm_class": "ssh-askpass"},  # ssh-askpass
        {"wm_class": "branchdialog"},  # gtik
        {"wm_class": "pinentry"},  # GPG key password entry
    ]

    font = "Cascadia Code"
    font_size = 14

    layout_margin = 10
    layout_border_focus = "#ffffff"
    layout_border_unfocus = "#00000000"

    bar_margin = [10, 10, 0, 10]
    bar_background = "#000000ff"

    widget_background = "#000000"
    widget_padding = 10
    widget_spacing = 10

    sys_script = os.path.expanduser("~/.config/custom-scripts/power-and-session")
    volume_script = os.path.expanduser("~/.config/custom-scripts/volume")
    brightness_script = os.path.expanduser("~/.config/custom-scripts/brightness")


# functions
@lazy.function
def window_to_next_monitor(qtile):
    if qtile.current_window is None:
        return
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


@lazy.function
def window_to_prev_monitor(qtile):
    if qtile.current_window is None:
        return
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


mod = "mod4"
terminal = guess_terminal()

scratchpads = []

groups = [
    Group(i, matches=[Match(**args) for args in Config.window_groups.get(i, [])])
    for i in Config.group_names
] + scratchpads


keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Monitor controls
    Key([mod], "bracketright", lazy.next_screen(), desc="Switch focus to next monitor"),
    Key(
        [mod],
        "bracketleft",
        lazy.prev_screen(),
        desc="Switch focus to previous monitor",
    ),
    Key(
        [mod, "shift"],
        "bracketright",
        window_to_next_monitor,
        lazy.next_screen(),
        desc="Move window to next monitor",
    ),
    Key(
        [mod, "shift"],
        "bracketleft",
        window_to_prev_monitor,
        lazy.prev_screen(),
        desc="Move window to previous monitor",
    ),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    # Apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "e", lazy.spawn("nautilus"), desc="Launch file manager"),
    Key(
        [mod],
        "space",
        lazy.spawn(
            "rofi -modi drun -show drun -display-drun Apps -theme ~/.config/rofi/themes/appmenu.rasi"
        ),
        desc="App launcher",
    ),
    Key([mod], "w", lazy.spawn("networkmanager_dmenu"), desc="Wifi list"),
    # System operations
    KeyChord(
        [mod],
        "0",
        [
            Key([], "e", lazy.shutdown(), desc="Logout"),
            Key([], "l", lazy.spawn(f"{Config.sys_script} lock"), desc="Lock screen"),
            Key([], "s", lazy.spawn(f"{Config.sys_script} suspend"), desc="Suspend"),
            Key(
                [],
                "r",
                lazy.spawn(f"{Config.sys_script} reboot"),
                desc="Retart system",
            ),
            Key(
                ["shift"],
                "s",
                lazy.spawn(f"{Config.sys_script} shutdown"),
                desc="Shutdown system",
            ),
        ],
    ),
    # Volume
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn(f"{Config.volume_script} increase"),
        desc="Increase volume",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn(f"{Config.volume_script} decrease"),
        desc="Decrease volume",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn(f"{Config.volume_script} mute"),
        desc="Mute volume",
    ),
    # Brightness
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn(f"{Config.brightness_script} inc"),
        desc="Increase brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn(f"{Config.brightness_script} dec"),
        desc="Increase brightness",
    ),
]

for i, group in enumerate(groups):
    if i >= abs(len(groups) - len(scratchpads)):
        break
    keys.extend(
        [
            # mod1 + number of group = switch to group
            Key(
                [mod],
                str(i + 1),
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod1 + shift + number of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                str(i + 1),
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
            # mod1 + control + number of group = only move focused window to group
            Key(
                [mod, "control"],
                str(i + 1),
                lazy.window.togroup(group.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
        ]
    )

layouts = [
    layout.MonadTall(
        margin=Config.layout_margin,
        border_focus=Config.layout_border_focus,
        border_normal=Config.layout_border_unfocus,
    ),
    layout.MonadWide(
        margin=Config.layout_margin,
        border_focus=Config.layout_border_focus,
        border_normal=Config.layout_border_unfocus,
    ),
    layout.Stack(
        num_stacks=1,
        margin=Config.layout_margin,
        border_focus=Config.layout_border_focus,
        border_normal=Config.layout_border_unfocus,
    ),
]

widget_defaults = dict(
    font=Config.font,
    fontsize=Config.font_size,
    padding=Config.widget_padding,
)
extension_defaults = widget_defaults.copy()

screens = []

for _ in range(Config.num_screens):
    screens.append(
        Screen(
            top=bar.Bar(
                [
                    widget.Spacer(10),
                    widget.GroupBox(
                        background=Config.widget_background,
                        padding=3,
                    ),
                    widget.Spacer(Config.widget_spacing),
                    widget.WindowName(
                        width=bar.CALCULATED,
                        background=Config.widget_background,
                        markup=True,
                        empty_group_string="[ ]",
                        format="[{state} {name} ]",
                        parse_text=lambda s: s[:20] + "..." if s is not None else s,
                    ),
                    widget.CurrentScreen(
                        active_text="●", inactive_text="", active_color="#ffffff"
                    ),
                    widget.Spacer(bar.STRETCH),
                    widget.Clock(
                        format="%a, %d %b, %I:%M %p",
                        background=Config.widget_background,
                    ),
                    widget.Spacer(bar.STRETCH),
                    widget.CurrentLayout(
                        fmt="[ {} ]"
                    ),
                    widget.Spacer(Config.widget_spacing),
                    widget.Image(
                        filename="~/.config/qtile/icons/wifi.png",
                        margin=4,
                        mouse_callbacks={
                            "Button1": lambda: subprocess.call(["networkmanager_dmenu"])
                        },
                    ),
                    widget.Wlan(
                        interface="wlp61s0",
                        format="{essid} ({percent:2.0%})",
                        disconnected_message="Disconnected",
                        background=Config.widget_background,
                        mouse_callbacks={
                            "Button1": lambda: subprocess.call(["networkmanager_dmenu"])
                        },
                        padding=3,
                    ),
                    widget.Spacer(Config.widget_spacing),
                    widget.Image(filename="~/.config/qtile/icons/volume.png", margin=2),
                    widget.Volume(background=Config.widget_background, padding=2),
                    widget.Spacer(Config.widget_spacing+3),
                    widget.BatteryIcon(
                        theme_path=os.path.expanduser("~/.config/qtile/icons/battery")
                    ),
                    widget.Battery(
                        format="{percent:2.0%}", show_short_text=False, padding=5
                    ),
                    widget.Spacer(10),
                ],
                26,
                margin=Config.bar_margin,
                background=Config.bar_background,
            ),
        ),
    )

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button3", lazy.window.disable_floating()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=Config.layout_border_focus,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        *[Match(**args) for args in Config.float_windows],
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# hooks
@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([script])


@hook.subscribe.screen_change
def on_screen_change(_):
    script = os.path.expanduser("~/.config/qtile/on_screen_change.sh")
    subprocess.call([script])
