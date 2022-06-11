#!/bin/bash

SEPARATOR=""
R_SEPARATOR=""
R_INSEP=""

BG="#000000"
ACCENT="#87afff"
BLACK="#000000"
RED="#da251d"
PINK="#eb71b7"
VIOLET="#d7b2ff"
WHITE="#ffffff"
BLUE="#617BE3"
ORANGE="#f39760"
DARK_ALT="#515559"
DARK="#292E42"
GREEN="#16B653"

# do_style('content', fg, bg)
function do_style(){
	printf "%s" "#[fg=$2]#[bg=$3]$1"
}


# style (name, title)
function style(){
	local _fg="_tmux${1}_fg"
	local _bg="_tmux${1}_bg"

	local fg="${!_fg}"
	local bg="${!_bg}"

	printf "%s" "#[fg=$fg]#[bg=$bg]$2"
}
