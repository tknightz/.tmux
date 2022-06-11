#!/bin/bash

source ~/.tmux/imports.sh


function _measurespeed(){
	RXB=0
	TXB=0
	for rxbytes in /sys/class/net/*/statistics/rx_bytes ; do
		let RXB+=$(<$rxbytes)
	done
	for txbytes in /sys/class/net/*/statistics/tx_bytes ; do
		let TXB+=$(<$txbytes)
	done

	sleep 2

	RXBN=0
	TXBN=0
	for rxbytes in /sys/class/net/*/statistics/rx_bytes ; do
		let RXBN+=$(<$rxbytes)
	done
	for txbytes in /sys/class/net/*/statistics/tx_bytes ; do
		let TXBN+=$(<$txbytes)
	done
	#divide by two for the period, multiply by 10 to allow a correct decimal place
	RXDIF=$(echo $(((RXBN - RXB) * 5  )))
	TXDIF=$(echo $(((TXBN - TXB) * 5  )))

	SPEEDU=" B/s"
	SPEEDD=" B/s"
	if [ $RXDIF -ge 10240 ]; then
		SPEEDD="Ki/s"
		RXDIF=$(echo $((RXDIF / 10240 )) )
	fi

	if [ $TXDIF -ge 10240 ]; then
		SPEEDU=" Ki/s"
		TXDIF=$(echo $((TXDIF / 10240 )) )
	fi

	if [ $RXDIF -ge 10240 ]; then
		SPEEDD=" Mi/s"
		RXDIF=$(echo $((RXDIF / 10240 )) )
	fi

	if [ $TXDIF -ge 10240 ]; then
		SPEEDU=" Mi/s"
		TXDIF=$(echo $((TXDIF / 10240 )) )
	fi

	if [ $RXDIF -ge 10240 ]; then
		SPEEDD=" Gi/s"
		RXDIF=$(echo $((RXDIF / 10240 )) )
	fi

	if [ $TXDIF -ge 10240 ]; then
		SPEEDU=" Gi/s"
		TXDIF=$(echo $((TXDIF / 10240 )) )
	fi

	RXDIFF=$(($RXDIF % 10 ))
	RXDIFI=$(( $RXDIF / 10 ))
	RXDIF="$RXDIFI"

	if [ $RXDIFF -ne 0 ]; then
		RXDIF=$( echo  "$RXDIFI.$RXDIFF" )
	fi

	TXDIFF=$(($TXDIF % 10 ))
	TXDIFI=$(( $TXDIF / 10 ))
	TXDIF="$TXDIFI"

	if [ $TXDIFF -ne 0 ]; then
		TXDIF=$( echo  "$TXDIFI.$TXDIFF" )
	fi

	# shellcheck disable=SC2086
	local dlspeed=$(printf "%s%s" $RXDIF $SPEEDD)
	local ulspeed=$(printf "%s%s" $TXDIF $SPEEDU)


	printf " %s - ↑ %s" "$dlspeed" "$ulspeed"
}

function _playing(){
  # require playerctl
	local song=""

	for m in `playerctl --list-all metadata`; do
		if [[ `playerctl --player=$m status` == 'Playing' ]]; then
			song=$(playerctl --player=$m metadata title)
		fi
	done

	len=${#song}
	hsong=${song:0:20}
	tsong=${song:len-5:len}

	# song=$(printf "%.15s" "$song")

	local main=$(do_style " ﱘ  $hsong..." $WHITE $DARK)
	local sep=$(do_style '' $DARK $BG)

	if [[ -n "$hsong" ]]
	then
		printf " %s " "$sep$main"
	else
		printf "$sep"
	fi
}


function _netspeed(){
	local speed="$(_measurespeed)"
	
	local main=$(do_style "$speed" $WHITE $RED)
	local sep=$(do_style '' $ORANGE $ACCENT)

	printf " %s " $main

}


_tmux_cpu_fg=$WHITE
_tmux_cpu_bg=$BLUE

function _cpu(){
	local usage=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%d", ($2+$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat))

	# local fg=$WHITE
	# local bg=$BLUE

	if [[ $(echo "$usage > 60" | bc) -eq 1 ]];
	then
		_tmux_cpu_bg=$RED
	elif [[ $(echo "$usage > 40" | bc) -eq 1 ]];
	then
		_tmux_cpu_bg=$PINK
	fi

	local main=$(do_style "   $usage% " $_tmux_cpu_fg $_tmux_cpu_bg)
	local sep=$(do_style '' $_tmux_cpu_bg $DARK)

	printf "%s" "$sep$main"
}

function _ram(){
	local usage=$(free -m | awk 'NR==2 {print substr( $3 / 1000, 1, 3 )}')
	# local total=$(free -m | awk 'NR==2 {print substr( $2 / 1000, 1, 3 )}')
	local sep=$(do_style '' $ACCENT $_tmux_cpu_bg)

	local content=$(printf " %sGb" $usage)

	local main=$(do_style " $content " $BG $ACCENT)
	printf "%s" "$sep$main"
}


function _datetime(){
	local dow=$(expr $(date +'%u') + 1)
	if [[ $dow -eq 8 ]]
	then
		dow="CN"
	else
		dow="T${dow}"
	fi


	local clock=$(date +'%H:%M')
	local datemonth=$(date +'%d/%m')

	local now=$(printf "%s" "$clock - $dow, $datemonth")

	local main=$(do_style "  $now " $BG $ORANGE)
	local sep=$(do_style '' $ORANGE $ACCENT)

	printf "%s" "$sep$main"

}

function _user(){
	# local username=$(whoami)
	local username=$(whoami)
	local fg=$WHITE
	local bg=$RED

	test "$username" -eq "root" && bg=$RED

	local main=$(do_style "   $username " $fg $bg)
	local sep=$(do_style '' $bg $ORANGE)

	printf "%s" "$sep"
}


function main(){
	_playing
	_cpu
	_ram
	_datetime
	_user
}

main
