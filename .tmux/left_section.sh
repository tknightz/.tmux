#!/bin/bash
source ~/.tmux/imports.sh

function _sessions(){
	local main=$(do_style '  #S ' $WHITE $RED)
	local sep=$(do_style '' $RED $PINK)
	printf "%s" "$main$sep"
}

function _uptime(){
	local uptime_str=$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1h \2min/')

	local main=$(do_style "  $uptime_str " $BG $PINK)
	local sep=$(do_style '  ' $PINK $BG)

	printf "%s" "$main$sep"
}

function main(){
	_sessions
	_uptime
}

main
