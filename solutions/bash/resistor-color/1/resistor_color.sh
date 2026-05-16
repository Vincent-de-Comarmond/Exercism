#!/usr/bin/env bash

declare -A values=(
	[black]=0
	[brown]=1
	[red]=2
	[orange]=3
	[yellow]=4
	[green]=5
	[blue]=6
	[violet]=7
	[grey]=8
	[white]=9
)

declare -A colors=(
	[0]=black
	[1]=brown
	[2]=red
	[3]=orange
	[4]=yellow
	[5]=green
	[6]=blue
	[7]=violet
	[8]=grey
	[9]=white
)

main() {
	if [[ "$1" == "colors" ]]; then
		for i in {0..9}; do
			echo "${colors[$i]}"
		done
	else
		echo "${values[$2]}"
	fi
}

main "$@"
