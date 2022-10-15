from subprocess import getoutput
from datetime import datetime
import json
from assets import colors
from vars import config


def do_style(title, fg, bg, icon):
    content = f" {icon}  {title} " if icon and title else title
    return f"#[fg={fg}]#[bg={bg}]{content}"


def make_style(section):
    title = globals()[section]()
    fg = colors[config[section]["fg"]]
    bg = colors[config[section]["bg"]]
    icon = config[section]["icon"]
    result = do_style(title, fg, bg, icon)

    if config[section].get("bold", False):
        result = f"#[bold]{result}#[nobold]"
    if config[section].get("italic", False):
        result = f"#[italics]{result}#[noitalics]"

    return result


def make_styles(sections, sep="", right=False):
    result = []
    for idx, section in enumerate(sections):
        title = globals()[section]()

        style = make_style(section)

        if sep != "":
            sep_fg = colors[config[section]["bg"]]

            sep_bg = colors["bg"]
            if not right:
                sep_bg = (
                    colors["bg"]
                    if idx == len(sections) - 1
                    else colors[config[sections[idx + 1]]["bg"]]
                )
            else:
                sep_bg = (
                    colors["bg"]
                    if idx == 0
                    else colors[config[sections[idx - 1]]["bg"]]
                )
            style_sep = do_style(sep, sep_fg, sep_bg, "")

            if right:
                style = style_sep + style
            else:
                style += style_sep

        result.append(style)
    return "".join(result)


def uptime():
    return getoutput(
        "uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\\1h \\2min/'"
    )


def session():
    return "#S"


def cpu():
    usage = float(getoutput( "awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf \"%d\", ($2+$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)"))

    if usage > 40:
        config["cpu"]["fg"] = config["cpu"]["fg_medium"]
    elif usage > 80:
        config["cpu"]["fg"] = config["cpu"]["fg_high"]
    else:
        config["cpu"]["fg"] = "blue"

    return str(usage) + "%"


def playing_info():
    raw_metadata = getoutput(
        'playerctl metadata -f \'{"{{lc(status)}}": "{{(title)}}"}\''
    )
    metadata = json.loads(raw_metadata)
    playing_title = metadata.get("playing", None)

    if playing_title is None:
        return ""

    return playing_title[:20] + " ... "


def ram():
    usage = float(getoutput("free -m | awk 'NR==2 {print substr( $3 / 1000, 1, 3 )}'"))
    if usage > 4:
        config["ram"]["fg"] = config["ram"]["fg_medium"]
    elif usage > 6:
        config["ram"]["fg"] = config["ram"]["fg_high"]
    else:
        config["ram"]["fg"] = "green"

    return str(usage) + "Gb"



def date():
    now = datetime.now()
    return now.strftime("%H:%M - %d/%m")


def user():
    return getoutput("whoami")


def window_active():
    return "#W"


def window():
    return "#W"
