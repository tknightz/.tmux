import sys
from utils import make_style, do_style
from assets import separators, colors
from vars import config


def active():
    style = make_style("window_active")
    bg = colors[config["window_active"]["bg"]]
    lsep = do_style(separators["left"], colors["bg"], bg, "")
    rsep = do_style(separators["left"], bg, colors["bg"], "")

    print(lsep + style + rsep)


def common():
    style = make_style("window")
    bg = colors[config["window"]["bg"]]
    lsep = do_style(separators["left"], colors["bg"], bg, "")
    rsep = do_style(separators["left"], bg, colors["bg"], "")

    print(lsep + style + rsep)


if __name__ == "__main__":
    if sys.argv[1] == "active":
        active()
    else:
        common()
