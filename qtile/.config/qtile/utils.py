from Xlib import display


def get_num_screens():
    d = display.Display()
    s = d.screen()
    r = s.root
    res = r.xrandr_get_screen_resources()._data

    num_screens = 0
    for output in res["outputs"]:
        mon = d.xrandr_get_output_info(output, res["config_timestamp"])._data
        if mon["num_preferred"]:
            num_screens += 1

    return num_screens
